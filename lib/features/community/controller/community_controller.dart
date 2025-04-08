import 'dart:io';

import 'package:business_application/core/services/auth_services.dart';
import 'package:business_application/features/community/data/comments_response_model.dart';
import 'package:business_application/features/community/data/community_posts_model.dart';
import 'package:business_application/features/community/data/posts_by_id_model.dart';
import 'package:business_application/features/community/data/topics_model.dart' as topics_model;
import 'package:business_application/features/groups/controller/groups_controller.dart';
import 'package:business_application/features/my_posts/controller/my_posts_controller.dart';
import 'package:business_application/features/notification/controller/notification_controller.dart';
import 'package:business_application/features/save_posts/controller/save_post_controller.dart';
import 'package:business_application/main.dart';
import 'package:business_application/repository/community_rep.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CommunityController extends GetxController {
  var isLoading = false.obs;
  var commentLoading = false.obs;
  var communityPosts = PostsResponseModel().obs;
  var comments = CommentsResponseModel().obs;
  var selectedPostId = 0.obs;
  var communityPostsById = PostByIdResponseModel().obs;
  var topics = topics_model.TopicsResponseModel().obs;
  var selectedTopic = ''.obs;
  topics_model.TopicsResponseModel? selectedTopicValue;
  var selectedTopicId = ''.obs;
  final TextEditingController postController = TextEditingController(); // No Rx wrapper
  final TextEditingController videoLinkController = TextEditingController();
  final FocusNode postFocusNode = FocusNode();
  final RxString selectedImage = "".obs;
  final RxInt selectedTabIndex = 0.obs;
  var filteredPosts = <Posts>[].obs;
  final ScrollController scrollController = ScrollController();
  RxDouble scrollOffset = 0.0.obs; // Change to RxDouble for reactivity
  RxBool shouldRestorePosition = false.obs;

  @override
  void onInit() {
    Get.find<AuthService>().getCurrentUser();
    getCommunityPosts();
    getTopic();

    Get.find<NotificationController>().checkNotification();
    selectedTopic.listen((value) {
      if (value.isNotEmpty) {
        final topic = topics.value.result?.data?.firstWhere((t) => t.name == value, orElse: () => topics_model.Topic());
        filterPostsByTopic(value, topicId: topic?.id?.toString());
      }
    });
    scrollController.addListener(() {
      scrollOffset.value = scrollController.offset;
    });
    super.onInit();
  }

  @override
  void onClose() {
    postController.dispose();
    videoLinkController.dispose();
    postFocusNode.dispose();
    scrollController.dispose();
    super.onClose();
  }

  static const imageLink =
      'https://s3-alpha-sig.figma.com/img/f8a3/11ee/624d5c6c6457029c05e89e81ac6882ab?Expires=1743379200&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=hScOEIqEn5wtub6NMJ849GdedyxVifSWD6fHLLn3qrc2E0eDGI7p~onPifLf0OAu29CzZTAYLhj4E8LDFs~koGpLUjNuqqsX4KJEpYFzSTL19RPR479kqW~i4SjjGuSviyb-I-6lQPC2imp7wZjtaobMqDT55ZO-eZaqb67d0qRBhR19vtIKgBRxkks3sSyNguPn3ZYCdUUa5VgUcyhGB2TDiei5~9zO211VLyEKu5uy5~~5-zpXPCdxuLUs0o8VFy65DTgbGfl1oB1r5snWHbPr~c4a32iSA9QvBWTzOf25b~jQnYrGddqxolA1z62I-3ueLavcGkacHO26W8GZjQ__';

  var selectedCommunityId = '1'.obs;

  void saveScrollPosition() {
    // Save the current scroll position
    if (scrollController.hasClients) {
      scrollOffset.value = scrollController.offset;
      shouldRestorePosition.value = true;
    }
  }

  void restoreScrollPosition() {
    if (shouldRestorePosition.value && scrollOffset.value > 0) {
      // Use a more reliable approach with WidgetsBinding
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Using a small delay to ensure the ListView is fully built
        Future.delayed(const Duration(milliseconds: 200), () {
          if (scrollController.hasClients) {
            try {
              scrollController.jumpTo(scrollOffset.value);
              print("Restored scroll position to: ${scrollOffset.value}");
            } catch (e) {
              print("Error restoring scroll position: $e");
            }
          } else {
            print("ScrollController has no clients");
          }
        });
      });
    }
  }

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

  void addComments({
    required BuildContext context,
    required String postId,
    required String comments,
    required String parentId,
  }) async {
    final response = await CommunityRep().createComments({
      "post_id": postId,
      "content": comments,
      "parent_id": parentId,
    }, context);
    print("comments response $response");
    getComments(postId);
  }

  deleteComments(String id, BuildContext context) async {
    try {
      isLoading(true);
      final response = await CommunityRep().deleteComment(id, context);
      print("delete comments response $response");
      getComments(selectedPostId.value.toString());
    } catch (e) {
      isLoading(false);
      print(e);
    } finally {
      isLoading(false);
    }
  }

  likePosts(BuildContext context) async {
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

    final response = await CommunityRep().likePosts(data, context);
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

  savePost(BuildContext context) async {
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

    final response = await CommunityRep().savePost(data, context);
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
      content: postController.text.trim(),
      topicId: selectedTopicId.value,
      imageFile: selectedFile,
      videoUrl: videoLinkController.text.isNotEmpty ? videoLinkController.text : null,
      groupId: groupId, // Pass groupId to the repository
    );

    if (response['success'] == true) {
      getCommunityPosts();
      clearPostData();
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
        imageFile: selectedFile,
        videoUrl: videoUrl,
        groupId: groupId,
      );

      if (response['success'] == true) {
        getCommunityPostsById(postId);
        getCommunityPosts();
        if (groupId != null) {
          Get.find<GroupsController>().fetchGroupPosts(groupId);
        }
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
      print("Error fetching post by ID: $e");
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
    final isDebug = true;

    if (isDebug) print("COMMUNITY CONTROLLER: Loading post data for ID: $postId");

    if (post != null && post.id.toString() == postId) {
      // Set content, image and video
      postController.text = post.content ?? '';
      selectedImage.value = post.image ?? '';
      videoLinkController.text = post.videoUrl ?? '';

      // Only set topic if it's not already set (to avoid overriding values already set)
      if (selectedTopic.value.isEmpty && post.topic != null) {
        selectedTopic.value = post.topic?.name ?? '';
        selectedTopicId.value = post.topic?.id?.toString() ?? '';
        if (isDebug)
          print("COMMUNITY CONTROLLER: Setting topic from post: ${selectedTopic.value}, ID: ${selectedTopicId.value}");
      } else if (isDebug) {
        print("COMMUNITY CONTROLLER: Keeping existing topic: ${selectedTopic.value}, ID: ${selectedTopicId.value}");
      }

      // Update the tab index based on whether there's a video URL or image
      if (post.videoUrl != null && post.videoUrl!.isNotEmpty) {
        selectedTabIndex.value = 1;
      } else {
        selectedTabIndex.value = 0;
      }
    } else {
      // Clear data for new posts
      postController.clear();
      videoLinkController.clear();
      selectedImage.value = '';
    }
  }

  void deletePost(String postId, BuildContext context) async {
    try {
      isLoading(true);
      final response = await CommunityRep().deletePost(postId, context);
      if (response['success'] == true) {
        Get.snackbar(
          "Success",
          response['message'] ?? "Post deleted successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(20),
          borderRadius: 8,
          duration: const Duration(seconds: 5),
        );
        getCommunityPosts(); // Refresh posts after deletion
      } else {
        print("Error deleting post: ${response['message']}");
      }
    } catch (e) {
      print("Error deleting post: $e");
    } finally {
      isLoading(false);
    } //
  }

  void clearPostData() {
    postController.clear();
    videoLinkController.clear();
    selectedImage.value = "";
    selectedTabIndex.value = 0;
    selectedTopic.value = "";
  }

  // Add these new methods to your CommunityController
  void likePostAndSyncState(BuildContext context, int postId, bool currentState) {
    // Make API call
    Map<String, dynamic> data = {"type": "App\\Models\\Post", "id": postId};
    CommunityRep().likePosts(data, context).then((response) {
      // If API call fails, revert UI
      if (response['success'] == false) {
        communityPostsById.value.result?.isLiked = currentState;
        communityPostsById.refresh();
      } else {
        // Update the post state in all relevant controllers
        _syncPostStateAcrossControllers(postId, 'like', !currentState);
      }
    });
  }

  void savePostAndSyncState(BuildContext context, int postId, bool currentState) {
    // Make API call
    Map<String, dynamic> data = {"post_id": postId};
    CommunityRep().savePost(data, context).then((response) {
      // If API call fails, revert UI
      if (response['success'] == false) {
        communityPostsById.value.result?.isSaved = currentState;
        communityPostsById.refresh();
      } else {
        // Update the post state in all relevant controllers
        _syncPostStateAcrossControllers(postId, 'save', !currentState);
      }
    });
  }

  // Helper method to sync state across controllers
  void _syncPostStateAcrossControllers(int postId, String action, bool newState) {
    // Update in main posts list
    int postIndex = communityPosts.value.result?.data?.indexWhere((p) => p.id == postId) ?? -1;
    if (postIndex != -1) {
      if (action == 'like') {
        communityPosts.value.result!.data![postIndex].isLiked = newState;
      } else if (action == 'save') {
        communityPosts.value.result!.data![postIndex].isSaved = newState;
      }
      communityPosts.refresh();
    }

    // Update in filtered posts list
    int filteredIndex = filteredPosts.indexWhere((p) => p.id == postId);
    if (filteredIndex != -1) {
      if (action == 'like') {
        filteredPosts[filteredIndex].isLiked = newState;
      } else if (action == 'save') {
        filteredPosts[filteredIndex].isSaved = newState;
      }
      filteredPosts.refresh();
    }

    // Update in GroupsController if it's registered
    try {
      if (Get.isRegistered<GroupsController>()) {
        final groupsController = Get.find<GroupsController>();
        int groupPostIndex = groupsController.groupPosts.indexWhere((p) => p.id == postId);
        if (groupPostIndex != -1) {
          if (action == 'like') {
            groupsController.groupPosts[groupPostIndex].isLiked = newState;
          } else if (action == 'save') {
            groupsController.groupPosts[groupPostIndex].isSaved = newState;
          }
          groupsController.groupPosts.refresh();
        }
      }
    } catch (e) {
      print("Error updating group post state: $e");
    }

    // Update in MyPostsController if available
    try {
      if (Get.isRegistered<MyPostsController>()) {
        final myPostsController = Get.find<MyPostsController>();
        int myPostIndex = myPostsController.myPosts.value.result?.data?.indexWhere((p) => p.id == postId) ?? -1;
        if (myPostIndex != -1) {
          if (action == 'like') {
            myPostsController.myPosts.value.result!.data![myPostIndex].isLiked = newState;
          } else if (action == 'save') {
            myPostsController.myPosts.value.result!.data![myPostIndex].isSaved = newState;
          }
          myPostsController.myPosts.refresh();
        }
      }
    } catch (e) {
      // MyPostsController might not be registered yet
      print("MyPostsController not available: $e");
    }

    // Update in SavePostController if available
    try {
      if (Get.isRegistered<SavePostController>()) {
        final savePostController = Get.find<SavePostController>();
        int savedPostIndex = savePostController.savePosts.value.result?.data?.indexWhere((p) => p.id == postId) ?? -1;
        if (savedPostIndex != -1) {
          if (action == 'like') {
            savePostController.savePosts.value.result!.data![savedPostIndex].isLiked = newState;
          } else if (action == 'save') {
            savePostController.savePosts.value.result!.data![savedPostIndex].isSaved = newState;
          }
          savePostController.savePosts.refresh();
        }
      }
    } catch (e) {
      // SavePostController might not be registered yet
      print("SavePostController not available: $e");
    }
  }

  // Add these methods to your CommunityController class:

  // Process a like action regardless of post type (group or regular)
  Future<void> processLike(BuildContext context, int postId) async {
    // Set the selected post ID
    selectedPostId.value = postId;

    // Call the like API endpoint
    Map<String, dynamic> data = {"type": "App\\Models\\Post", "id": postId};
    await CommunityRep().likePosts(data, context);
  }

  // Process a save action regardless of post type (group or regular)
  Future<void> processSave(BuildContext context, int postId) async {
    // Set the selected post ID
    selectedPostId.value = postId;

    // Call the save API endpoint
    Map<String, dynamic> data = {"post_id": postId};
    await CommunityRep().savePost(data, context);
  }
}
