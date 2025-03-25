import 'dart:io';

import 'package:business_application/core/utils/ui_support.dart';
import 'package:business_application/features/community/data/comments_response_model.dart';
import 'package:business_application/features/community/data/community_model.dart';
import 'package:business_application/core/services/auth_services.dart';
import 'package:business_application/features/community/data/community_posts_model.dart';
import 'package:business_application/features/community/data/posts_by_id_model.dart';
import 'package:business_application/features/community/data/topics_model.dart' as topics_model;
import 'package:business_application/repository/community_rep.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CommunityController extends GetxController {
  var isLoading = false.obs;
  var communityPosts = PostsResponseModel().obs;
  var comments = CommentsResponseModel().obs;
  var selectedPostId = 0.obs;
  var communityPostsById = PostByIdResponseModel().obs;
  var topics = topics_model.TopicsResponseModel().obs;
  var selectedTopic = ''.obs;
  topics_model.TopicsResponseModel? selectedTopicValue;
  var selectedTopicId = ''.obs; // Initialize as an empty observable list
  final TextEditingController postController = TextEditingController();
  var selectedImage = "".obs;
  final RxInt selectedTabIndex = 0.obs; // 0 for Image, 1 for Video
  final TextEditingController videoLinkController = TextEditingController();
  var filteredPosts = <Posts>[].obs; // Observable for filtered posts

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      selectedImage.value = pickedFile.path;
    }
  }

  @override
  void onInit() {
    Get.find<AuthService>().getCurrentUser();
    getCommunityPosts();
    getTopic();
    selectedTopic.listen((value) {
      if (value.isNotEmpty && value != "All") {
        filterPostsByTopic(value); // Filter posts locally
      } else {
        filteredPosts.assignAll(communityPosts.value.result?.data ?? []); // Show all posts if "All" is selected
      }
    });
    super.onInit();
  }

  static const imageLink =
      'https://s3-alpha-sig.figma.com/img/f8a3/11ee/624d5c6c6457029c05e89e81ac6882ab?Expires=1743379200&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=hScOEIqEn5wtub6NMJ849GdedyxVifSWD6fHLLn3qrc2E0eDGI7p~onPifLf0OAu29CzZTAYLhj4E8LDFs~koGpLUjNuqqsX4KJEpYFzSTL19RPR479kqW~i4SjjGuSviyb-I-6lQPC2imp7wZjtaobMqDT55ZO-eZaqb67d0qRBhR19vtIKgBRxkks3sSyNguPn3ZYCdUUa5VgUcyhGB2TDiei5~9zO211VLyEKu5uy5~~5-zpXPCdxuLUs0o8VFy65DTgbGfl1oB1r5snWHbPr~c4a32iSA9QvBWTzOf25b~jQnYrGddqxolA1z62I-3ueLavcGkacHO26W8GZjQ__';
  var communities =
      <Community>[
        Community(id: '1', name: 'Tech Enthusiasts', newPosts: 5, totalMembers: 120, imageUrl: imageLink),
        Community(id: '2', name: 'Fitness Freaks', newPosts: 2, totalMembers: 80, imageUrl: imageLink),
        Community(id: '3', name: 'Book Lovers', newPosts: 10, totalMembers: 200, imageUrl: imageLink),
      ].obs;

  var selectedCommunityId = '1'.obs;

  void changeCommunity(String communityId) {
    selectedCommunityId.value = communityId;
  }

  getCommunityPosts() async {
    try {
      isLoading(true);
      final response = await CommunityRep().getCommunityPosts();
      communityPosts(PostsResponseModel.fromJson(response));
      // Initialize filteredPosts with all posts after fetching
      filteredPosts.assignAll(communityPosts.value.result?.data ?? []);
    } catch (e) {
      isLoading(false);
      print(e);
    } finally {
      isLoading(false);
    }
  }

  void filterPostsByTopic(String topicName) {
    final allPosts = communityPosts.value.result?.data ?? [];
    if (topicName == "All") {
      filteredPosts.assignAll(allPosts); // Show all posts for "All" topic
    } else {
      filteredPosts.assignAll(allPosts.where((post) => post.topic?.name == topicName).toList());
    }
  }

  addComments({required String postId, required String comments, required String parentId}) async {
    try {
      final response = await CommunityRep().createComments({
        "post_id": postId,
        "content": comments,
        "parent_id": parentId,
      });
      print("comments response $response");
      getComments(postId);
      if (response['success'] != true) {
        ScaffoldMessenger.of(
          Get.context!,
        ).showSnackBar(SnackBar(content: Text(response['message']), backgroundColor: Colors.red));
      }
    } catch (e) {
      print(e);
    }
  }

  likePosts() async {
    int postIndex = communityPosts.value.result?.data?.indexWhere((post) => post.id == selectedPostId.value) ?? -1;

    if (postIndex == -1) return;

    bool previousState = communityPosts.value.result!.data![postIndex].isLiked!;

    // Optimistically update UI
    communityPosts.update((posts) {
      posts?.result?.data?[postIndex].isLiked = !previousState;
    });

    // Update filteredPosts to reflect the change
    int filteredIndex = filteredPosts.indexWhere((post) => post.id == selectedPostId.value);
    if (filteredIndex != -1) {
      filteredPosts[filteredIndex].isLiked = !previousState;
      filteredPosts.refresh(); // Trigger UI update
    }

    // Update communityPostsById to reflect the change
    if (communityPostsById.value.result?.id == selectedPostId.value) {
      communityPostsById.update((post) {
        post?.result?.isLiked = !previousState;
      });
    }

    Map<String, dynamic> data = {"type": "App\\Models\\Post", "id": selectedPostId.value};

    final response = await CommunityRep().likePosts(data);
    if (response['success'] == false) {
      // Revert if API fails
      communityPosts.update((posts) {
        posts?.result?.data?[postIndex].isLiked = previousState;
      });

      if (filteredIndex != -1) {
        filteredPosts[filteredIndex].isLiked = previousState;
        filteredPosts.refresh(); // Trigger UI update
      }

      if (communityPostsById.value.result?.id == selectedPostId.value) {
        communityPostsById.update((post) {
          post?.result?.isLiked = previousState;
        });
      }

      Ui.errorSnackBar(message: response['message']);
    }
  }

  savePost() async {
    int postIndex = communityPosts.value.result?.data?.indexWhere((post) => post.id == selectedPostId.value) ?? -1;

    if (postIndex == -1) return;

    bool previousState = communityPosts.value.result!.data![postIndex].isSaved!;

    // Optimistically update UI
    communityPosts.update((posts) {
      posts?.result?.data?[postIndex].isSaved = !previousState;
    });

    // Update filteredPosts to reflect the change
    int filteredIndex = filteredPosts.indexWhere((post) => post.id == selectedPostId.value);
    if (filteredIndex != -1) {
      filteredPosts[filteredIndex].isSaved = !previousState;
      filteredPosts.refresh(); // Trigger UI update
    }

    // Update communityPostsById to reflect the change
    if (communityPostsById.value.result?.id == selectedPostId.value) {
      communityPostsById.update((post) {
        post?.result?.isSaved = !previousState;
      });
    }

    Map<String, dynamic> data = {"post_id": selectedPostId.value};

    final response = await CommunityRep().savePost(data);
    if (response['success'] == false) {
      // Revert if API fails
      communityPosts.update((posts) {
        posts?.result?.data?[postIndex].isSaved = previousState;
      });

      if (filteredIndex != -1) {
        filteredPosts[filteredIndex].isSaved = previousState;
        filteredPosts.refresh(); // Trigger UI update
      }

      if (communityPostsById.value.result?.id == selectedPostId.value) {
        communityPostsById.update((post) {
          post?.result?.isSaved = previousState;
        });
      }

      Ui.errorSnackBar(message: response['message']);
    }
  }

  getComments(String id) async {
    try {
      isLoading(true);
      final response = await CommunityRep().getCommentsByPostId(id);
      comments(CommentsResponseModel.fromJson(response));
    } catch (e) {
      isLoading(false);
      print(e);
    } finally {
      isLoading(false);
    }
  }

  createNewPosts() async {
    File? selectedFile = selectedImage.value.isNotEmpty ? File(selectedImage.value) : null;

    final response = await CommunityRep().communityPosts(
      content: postController.text,
      topicId: selectedTopicId.value,
      imageFile: selectedFile, // Pass image if selected
      videoUrl: videoLinkController.text.isNotEmpty ? videoLinkController.text : null, // Pass video URL if provided
    );

    if (response['success'] == true) {
      getCommunityPosts();
      postController.clear();
      selectedImage.value = "";
      videoLinkController.clear();
      selectedTopicId.value = '';
      selectedTopic.value = '';
      selectedTabIndex.value = 0;
      Ui.successSnackBar(message: response['message']);
    } else {
      Ui.errorSnackBar(message: response['message']);
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
      topicsData.result?.data?.insert(0, topics_model.Topic(name: "All")); // Add "All" topic at the beginning
      topics(topicsData);
      selectedTopic.value = "All"; // Set "All" as the default selected topic
    } catch (e) {
      isLoading(false);
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
