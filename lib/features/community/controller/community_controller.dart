import 'dart:io';

import 'package:business_application/core/services/auth_services.dart';
import 'package:business_application/features/community/data/comments_response_model.dart';
import 'package:business_application/features/community/data/community_posts_model.dart';
import 'package:business_application/features/community/data/posts_by_id_model.dart';
import 'package:business_application/features/community/data/topics_model.dart' as topics_model;
import 'package:business_application/main.dart';
import 'package:business_application/repository/community_rep.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CommunityController extends GetxController {
  var isLoading = false.obs;
  var isPostDataLoaded = false.obs;
  var commentLoading = false.obs;
  var communityPosts = PostsResponseModel().obs;
  var comments = CommentsResponseModel().obs;
  var selectedPostId = 0.obs;
  var communityPostsById = PostByIdResponseModel().obs;
  var topics = topics_model.TopicsResponseModel().obs;
  var selectedTopic = ''.obs;
  topics_model.TopicsResponseModel? selectedTopicValue;
  var selectedTopicId = ''.obs;
  final TextEditingController postController = TextEditingController();
  var selectedImage = "".obs;
  final RxInt selectedTabIndex = 0.obs;
  final TextEditingController videoLinkController = TextEditingController();
  var filteredPosts = <Posts>[].obs;

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileSize = await file.length();

      if (fileSize > 2 * 1024 * 1024) {
        // Check if file size exceeds 2 MB
        scaffoldMessengerKey.currentState!.showSnackBar(
          SnackBar(content: Text("Image size must be less than 2 MB"), backgroundColor: Colors.red),
        );
        return;
      }

      selectedImage.value = pickedFile.path;
    }
  }

  @override
  void onInit() {
    Get.find<AuthService>().getCurrentUser();
    getCommunityPosts();
    getTopic();
    selectedTopic.listen((value) {
      if (value.isNotEmpty) {
        final topic = topics.value.result?.data?.firstWhere((t) => t.name == value, orElse: () => topics_model.Topic());
        filterPostsByTopic(value, topicId: topic?.id?.toString());
      }
    });
    super.onInit();
  }

  static const imageLink =
      'https://s3-alpha-sig.figma.com/img/f8a3/11ee/624d5c6c6457029c05e89e81ac6882ab?Expires=1743379200&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=hScOEIqEn5wtub6NMJ849GdedyxVifSWD6fHLLn3qrc2E0eDGI7p~onPifLf0OAu29CzZTAYLhj4E8LDFs~koGpLUjNuqqsX4KJEpYFzSTL19RPR479kqW~i4SjjGuSviyb-I-6lQPC2imp7wZjtaobMqDT55ZO-eZaqb67d0qRBhR19vtIKgBRxkks3sSyNguPn3ZYCdUUa5VgUcyhGB2TDiei5~9zO211VLyEKu5uy5~~5-zpXPCdxuLUs0o8VFy65DTgbGfl1oB1r5snWHbPr~c4a32iSA9QvBWTzOf25b~jQnYrGddqxolA1z62I-3ueLavcGkacHO26W8GZjQ__';

  var selectedCommunityId = '1'.obs;

  void changeCommunity(String communityId) {
    selectedCommunityId.value = communityId;
  }

  getCommunityPosts() async {
    try {
      isLoading(true);
      final response = await CommunityRep().getCommunityPosts();
      communityPosts(PostsResponseModel.fromJson(response));
      filteredPosts.assignAll(communityPosts.value.result?.data ?? []);
    } catch (e) {
      isLoading(false);
      print(e);
    } finally {
      isLoading(false);
    }
  }

  void filterPostsByTopic(String topicName, {String? topicId}) async {
    if (topicName == "All") {
      try {
        isLoading(true);
        final response = await CommunityRep().getCommunityPosts();
        communityPosts(PostsResponseModel.fromJson(response));
        filteredPosts.assignAll(communityPosts.value.result?.data ?? []);
      } catch (e) {
        print("Error fetching all posts: $e");
      } finally {
        isLoading(false);
      }
    } else {
      try {
        isLoading(true);
        final response = await CommunityRep().getCommunityPosts(params: {'topic_id': topicId});
        communityPosts(PostsResponseModel.fromJson(response));
        filteredPosts.assignAll(communityPosts.value.result?.data ?? []);
      } catch (e) {
        print("Error fetching posts by topic: $e");
      } finally {
        isLoading(false);
      }
    }
  }

  addComments({required String postId, required String comments, required String parentId}) async {
    final response = await CommunityRep().createComments({
      "post_id": postId,
      "content": comments,
      "parent_id": parentId,
    });
    print("comments response $response");
    getComments(postId);
    if (response['success'] == true) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(content: Text(response['message']), backgroundColor: Colors.green),
      );
    }
  }

  deleteComments(String id) async {
    try {
      isLoading(true);
      final response = await CommunityRep().deleteComment(id);
      print("delete comments response $response");
      getComments(selectedPostId.value.toString());
    } catch (e) {
      isLoading(false);
      print(e);
    } finally {
      isLoading(false);
    }
  }

  likePosts() async {
    int postIndex = communityPosts.value.result?.data?.indexWhere((post) => post.id == selectedPostId.value) ?? -1;

    if (postIndex == -1) return;

    bool previousState = communityPosts.value.result!.data![postIndex].isLiked!;

    communityPosts.update((posts) {
      posts?.result?.data?[postIndex].isLiked = !previousState;
    });

    int filteredIndex = filteredPosts.indexWhere((post) => post.id == selectedPostId.value);
    if (filteredIndex != -1) {
      filteredPosts[filteredIndex].isLiked = !previousState;
      filteredPosts.refresh();
    }

    if (communityPostsById.value.result?.id == selectedPostId.value) {
      communityPostsById.update((post) {
        post?.result?.isLiked = !previousState;
      });
    }

    Map<String, dynamic> data = {"type": "App\\Models\\Post", "id": selectedPostId.value};

    final response = await CommunityRep().likePosts(data);
    if (response['success'] == false) {
      communityPosts.update((posts) {
        posts?.result?.data?[postIndex].isLiked = previousState;
      });

      if (filteredIndex != -1) {
        filteredPosts[filteredIndex].isLiked = previousState;
        filteredPosts.refresh();
      }

      if (communityPostsById.value.result?.id == selectedPostId.value) {
        communityPostsById.update((post) {
          post?.result?.isLiked = previousState;
        });
      }
    }
  }

  savePost() async {
    int postIndex = communityPosts.value.result?.data?.indexWhere((post) => post.id == selectedPostId.value) ?? -1;

    if (postIndex == -1) return;

    bool previousState = communityPosts.value.result!.data![postIndex].isSaved!;

    communityPosts.update((posts) {
      posts?.result?.data?[postIndex].isSaved = !previousState;
    });

    int filteredIndex = filteredPosts.indexWhere((post) => post.id == selectedPostId.value);
    if (filteredIndex != -1) {
      filteredPosts[filteredIndex].isSaved = !previousState;
      filteredPosts.refresh();
    }

    if (communityPostsById.value.result?.id == selectedPostId.value) {
      communityPostsById.update((post) {
        post?.result?.isSaved = !previousState;
      });
    }

    Map<String, dynamic> data = {"post_id": selectedPostId.value};

    final response = await CommunityRep().savePost(data);
    if (response['success'] == false) {
      communityPosts.update((posts) {
        posts?.result?.data?[postIndex].isSaved = previousState;
      });

      if (filteredIndex != -1) {
        filteredPosts[filteredIndex].isSaved = previousState;
        filteredPosts.refresh();
      }

      if (communityPostsById.value.result?.id == selectedPostId.value) {
        communityPostsById.update((post) {
          post?.result?.isSaved = previousState;
        });
      }
    }
  }

  getComments(String id) async {
    try {
      commentLoading(true);
      final response = await CommunityRep().getCommentsByPostId(id);
      comments(CommentsResponseModel.fromJson(response));
    } catch (e) {
      commentLoading(false);
      print(e);
    } finally {
      commentLoading(false);
    }
  }

  createNewPosts({String? groupId}) async {
    File? selectedFile = selectedImage.value.isNotEmpty ? File(selectedImage.value) : null;

    final response = await CommunityRep().communityPosts(
      content: postController.text,
      topicId: selectedTopicId.value,
      imageFile: selectedFile,
      videoUrl: videoLinkController.text.isNotEmpty ? videoLinkController.text : null,
      groupId: groupId, // Pass groupId to the repository
    );

    if (response['success'] == true) {
      getCommunityPosts();
      postController.clear();
      selectedImage.value = "";
      videoLinkController.clear();
      selectedTopicId.value = '';
      selectedTopic.value = '';
      selectedTabIndex.value = 0;
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(content: Text(response['message']), backgroundColor: Colors.green),
      );
    } else {
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(content: Text(response['message']), backgroundColor: Colors.red),
      );
    }
  }

  void updatePost({
    required String content,
    required String postId,
    required String topicId,
    String? videoUrl,
    String? groupId,
  }) async {
    try {
      isLoading(true);

      // Check if the selectedImage is a local file path or a URL
      File? selectedFile;
      if (selectedImage.value.isNotEmpty && !selectedImage.value.startsWith('http')) {
        selectedFile = File(selectedImage.value); // Only create a File object for local paths
      }

      final response = await CommunityRep().updatePosts(
        content: content,
        postId: postId,
        topicId: topicId,
        imageFile: selectedFile, // Pass the File object or null
        videoUrl: videoUrl,
        groupId: groupId,
      );

      if (response['success'] == true) {
        getCommunityPosts();
        postController.clear();
        selectedImage.value = "";
        videoLinkController.clear();
        selectedTopicId.value = '';
        selectedTopic.value = '';
        selectedTabIndex.value = 0;
        scaffoldMessengerKey.currentState!.showSnackBar(
          SnackBar(content: Text(response['message']), backgroundColor: Colors.green),
        );
      } else {
        scaffoldMessengerKey.currentState!.showSnackBar(
          SnackBar(content: Text(response['message']), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print("Error updating post: $e");
    } finally {
      isLoading(false);
    }
  }

  getCommunityPostsById(String id) async {
    try {
      isLoading(true);
      final response = await CommunityRep().getCommunityPostsById(id);
      communityPostsById(PostByIdResponseModel.fromJson(response));
      getComments(id);
    } catch (e) {
      isLoading(false);
      print(e);
    } finally {
      isLoading(false);
    }
  }

  getTopic() async {
    try {
      isLoading(true);
      final response = await CommunityRep().getTopics();
      final topicsData = topics_model.TopicsResponseModel.fromJson(response);
      topicsData.result?.data?.insert(0, topics_model.Topic(name: "All"));
      topics(topicsData);
      selectedTopic.value = "All";
    } catch (e) {
      isLoading(false);
      print(e);
    } finally {
      isLoading(false);
    }
  }

  void loadPostData(String postId) {
    final post = communityPostsById.value.result;
    if(isPostDataLoaded.value) {
      return; // Prevent loading if already loaded
    }
    if (post != null && post.id.toString() == postId) {
      postController.text = post.content ?? ''; // Properly set the text content
      selectedImage.value = post.image ?? '';
      videoLinkController.text = post.videoUrl ?? '';
      selectedTopic.value = post.topic?.name ?? '';
      selectedTopicId.value = post.topic?.id?.toString() ?? '';
      isPostDataLoaded.value = true;
    }
  }
}
