import 'dart:io';

import 'package:business_application/core/services/auth_services.dart';
import 'package:business_application/data/posts/posts_models.dart';
import 'package:business_application/data/posts/topic_models.dart' as topics_model;
import 'package:business_application/features/community/data/comments_by_id_response.dart';
import 'package:business_application/features/community/data/comments_response_model.dart';
import 'package:business_application/features/community/data/community_posts_model.dart';
import 'package:business_application/features/community/data/posts_by_id_model.dart';
import 'package:business_application/features/community/data/topics_model.dart';
import 'package:business_application/features/groups/controller/groups_controller.dart';
import 'package:business_application/features/my_posts/controller/my_posts_controller.dart';
import 'package:business_application/features/notification/controller/notification_controller.dart';
import 'package:business_application/features/save_posts/controller/save_post_controller.dart';
import 'package:business_application/main.dart';
import 'package:business_application/repository/community_rep.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CommunityController extends GetxController {
  var isLoading = false.obs;
  var shouldScrollToTop = false.obs;
  var commentLoading = false.obs;
  var communityPosts = PostsResponseModel().obs;
  var comments = CommentsResponseModel().obs;
  var commentById = CommentsByIdResponseModel().obs;
  var selectedPostId = 0.obs;
  var communityPostsById = PostByIdResponseModel().obs;
  var topics = TopicsResponseModel().obs;
  TopicsResponseModel? selectedTopicValue;
  var selectedTopic = 'All'.obs;
  var selectedTopicId = ''.obs;
  var editSelectedTopic = ''.obs;
  var editSelectedTopicId = ''.obs;
  final TextEditingController createPostController = TextEditingController(); // For creating posts
  final TextEditingController editPostController = TextEditingController(); // For editing posts
  final TextEditingController videoLinkController = TextEditingController();
  final TextEditingController editVideoController = TextEditingController();
  final FocusNode postFocusNode = FocusNode();
  final RxString selectedImage = "".obs;
  final RxString editSelectedImage = "".obs;
  final RxInt selectedTabIndex = 0.obs;
  var filteredPosts = <Posts>[].obs;
  ScrollController scrollController = ScrollController();
  ScrollController feedScrollController = ScrollController();
  RxDouble scrollOffset = 0.0.obs; // Change to RxDouble for reactivity
  RxBool shouldRestorePosition = false.obs;
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  // pagination state variable
  var currentPage = 1.obs;
  var nextPageUrl = ''.obs;
  var isPaginating = false.obs;

  //comments pagination
  var commentsPage = 1.obs;
  var commentsNextPageUrl = ''.obs;
  var isCommentsPaginating = false.obs;
  final ScrollController commentsScrollController = ScrollController();

  @override
  void onInit() async {
    Get.find<AuthService>().getCurrentUser();
    await getCommunityPosts();
    filterPostsByTopic('All');
    await getTopic();

    Get.find<NotificationController>().checkNotification(Get.context!);
    selectedTopic.listen((value) {
      if (value.isNotEmpty) {
        final topic = topics.value.result?.data?.firstWhere(
          (t) => t.name == value,
          orElse: () => topics_model.Topic(),
        );
        filterPostsByTopic(value, topicId: topic?.id?.toString());
      }
    });
    // scrollController.addListener(() {
    //   scrollOffset.value = scrollController.offset;
    // });
    super.onInit();
  }

  @override
  void onClose() {
    // Dispose of both controllers
    createPostController.dispose();
    editPostController.dispose();
    videoLinkController.dispose();
    postFocusNode.dispose();
    if (scrollController.hasClients) {
      scrollController.dispose();
    }
    if (feedScrollController.hasClients) {
      feedScrollController.dispose();
    }
    if (commentsScrollController.hasClients) {
      commentsScrollController.dispose();
    }

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

  void restoreScrollPosition(ScrollController controller) {
    if (shouldRestorePosition.value && scrollOffset.value > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.hasClients) {
          try {
            controller.jumpTo(scrollOffset.value);
            debugPrint("Restored scroll position to: ${scrollOffset.value}");
          } catch (e) {
            debugPrint("Error restoring scroll position: $e");
          }
        } else {
          debugPrint("ScrollController has no clients");
        }
      });
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      File? compressFile = await compressImageTo2MB(file);

      selectedImage.value = compressFile?.path ?? pickedFile.path;
      debugPrint("Edit image path: ${compressFile!.path}");
      debugPrint("Picked file path : ${pickedFile.path}");
      if (compressFile.lengthSync() > 2 * 1024 * 1024) {
        Get.snackbar(
          "Error",
          "Image size exceeds 2MB after compression",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(20),
          borderRadius: 8,
        );
        debugPrint("Image size exceeds 2MB after compression");
      } else {
        debugPrint("Image size is within limit");
      }
    }
  }

  Future<void> pickEditImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      final fileSize = await file.length();

      File? compressFile = await compressImageTo2MB(file);

      editSelectedImage.value = compressFile!.path;
      debugPrint("Edit image path: ${compressFile.path}");
      debugPrint("compress file length: ${compressFile.lengthSync()}");
      debugPrint("Picked file path : ${pickedFile.path}");
      debugPrint("Picked file length: $fileSize");
    }
  }

  // compressed the image
  Future<File?> compressImageTo2MB(File file) async {
    int maxSizeInBytes = 2 * 1024 * 1024; // 2MB in bytes
    int quality = 95;
    File? compressedFile = file;
    while ((await compressedFile!.length()) > maxSizeInBytes && quality > 10) {
      final dir = await getTemporaryDirectory();
      final targetPath = '${dir.path}/temp${file.path.split('/').last}';
      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
        format: CompressFormat.jpeg,
      );
      if (result != null) {
        compressedFile = File(result.path);
      }
      quality -= 5;
    }
    return compressedFile;
  }

  void changeCommunity(String communityId) {
    selectedCommunityId.value = communityId;
  }

  Future<void> getCommunityPosts() async {
    try {
      isLoading(true);
      final response = await CommunityRep().getCommunityPosts();
      communityPosts(PostsResponseModel.fromJson(response));
      filteredPosts.assignAll(communityPosts.value.result?.data ?? []);
      currentPage.value = communityPosts.value.result?.meta?.currentPage ?? 1;
      nextPageUrl.value = communityPosts.value.result?.links?.next ?? "";
    } catch (e) {
      isLoading(false);
      debugPrint("Error fetching community posts: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadNextPage() async {
    if (isPaginating.value || nextPageUrl.value.isEmpty) return;
    try {
      isPaginating(true);
      final response = await CommunityRep().getCommunityPosts(fullUrl: nextPageUrl.value);
      final newPosts = PostsResponseModel.fromJson(response);
      communityPosts.value.result?.data?.addAll(newPosts.result?.data ?? []);
      filteredPosts.addAll(newPosts.result?.data ?? []);
      currentPage.value = newPosts.result?.meta?.currentPage ?? 1;
      nextPageUrl.value = newPosts.result?.links?.next ?? "";
    } catch (e) {
      debugPrint("Error loading next page: $e");
    } finally {
      isPaginating(false);
    }
  }

  void filterPostsByTopic(String topicName, {String? topicId}) async {
    if (topicName == "All") {
      try {
        isLoading(true);
        final response = await CommunityRep().getCommunityPosts();
        communityPosts(PostsResponseModel.fromJson(response));
        filteredPosts.assignAll(communityPosts.value.result?.data ?? []);
        currentPage.value = communityPosts.value.result?.meta?.currentPage ?? 1;
        nextPageUrl.value = communityPosts.value.result?.links?.next ?? "";
      } catch (e) {
        debugPrint("Error fetching all posts: $e");
      } finally {
        isLoading(false);
      }
    } else {
      try {
        isLoading(true);
        final response = await CommunityRep().getCommunityPosts(params: {'topic_id': topicId});
        communityPosts(PostsResponseModel.fromJson(response));
        filteredPosts.assignAll(communityPosts.value.result?.data ?? []);
        currentPage.value = communityPosts.value.result?.meta?.currentPage ?? 1;
        nextPageUrl.value = communityPosts.value.result?.links?.next ?? "";
      } catch (e) {
        debugPrint("Error fetching posts by topic: $e");
      } finally {
        isLoading(false);
      }
    }
  }

  String cleanHtml(String rawHtml) {
    String updated = rawHtml;

    // Convert <br> to newlines
    updated = updated.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');

    // Remove carriage returns
    updated = updated.replaceAll('\r', '');

    // Optional: remove custom tags like <t>
    updated = updated.replaceAll(RegExp(r'</?t>'), '');

    // ✅ Remove all other HTML tags
    updated = updated.replaceAll(RegExp(r'<[^>]*>'), '');

    // Optionally collapse multiple newlines
    updated = updated.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    return updated.trim();
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

    if (response['success'] == true) {
      // Increment the comments count for the selected post
      communityPostsById.update((post) {
        if (post?.result != null && post!.result!.commentsCount != null) {
          post.result!.commentsCount = (post.result!.commentsCount! + 1);
        }
      });

      // Synchronize the comments count across controllers
      syncCommentsCountAcrossControllers(postId, 1);

      // Refresh the comments and post details
      filteredPosts.refresh();
      communityPosts.refresh();
    }

    debugPrint("comments response $response");
    getComments(postId);
  }

  Future<bool> getCommentById(String id) async {
    try {
      commentLoading(true);
      final response = await CommunityRep().getCommentsById(id);
      commentById(CommentsByIdResponseModel.fromJson(response));
      debugPrint("comments by id response: ${commentById.value.result}");
      return true;
    } catch (e) {
      debugPrint("Error fetching comment by ID: $e");
      return false;
    } finally {
      commentLoading(false);
    }
  }

  Future<void> deleteComments(String id, String postId, BuildContext context) async {
    try {
      isLoading(true);
      final response = await CommunityRep().deleteComment(id, context);

      if (response['success'] == true) {
        // Decrement the comments count for the selected post
        debugPrint("inside the success ======");
        communityPostsById.update((post) {
          if (post?.result != null && post!.result!.commentsCount != null) {
            post.result!.commentsCount =
                (post.result!.commentsCount! - 1).clamp(0, double.infinity).toInt();
          }
        });
        // Synchronize the comments count across controllers
        syncCommentsCountAcrossControllers(postId, -1);

        // Refresh the comments list
        comments.update((val) {
          val?.result?.data?.removeWhere((comment) => comment.id.toString() == id);
        });
        comments.refresh();

        // Refresh the filtered posts and community posts
        filteredPosts.refresh();
        communityPosts.refresh();
      } else {
        debugPrint("Failed to delete comment: ${response['message']}");
      }

      debugPrint("delete comments response $response");
    } catch (e) {
      debugPrint("Error deleting comment: $e");
    } finally {
      isLoading(false);
    }
  }

  // Helper method to synchronize comments count across controllers
  void syncCommentsCountAcrossControllers(String postId, int delta) {
    // Ensure postId is parsed to int once
    final postIdInt = int.tryParse(postId);
    debugPrint("Post ID=============================: $postIdInt");

    // Update in filtered posts list
    int filteredIndex = filteredPosts.indexWhere((p) => p.id == postIdInt);
    if (filteredIndex != -1) {
      filteredPosts[filteredIndex].commentsCount =
          ((filteredPosts[filteredIndex].commentsCount ?? 0) + delta)
              .clamp(0, double.infinity)
              .toInt();
      filteredPosts.refresh();
    }

    // Update in GroupsController if registered
    if (Get.isRegistered<GroupsController>()) {
      final groupsController = Get.find<GroupsController>();
      int groupPostIndex = groupsController.groupPosts.indexWhere((p) => p.id == postIdInt);
      if (groupPostIndex != -1) {
        groupsController.groupPosts[groupPostIndex].commentsCount =
            ((groupsController.groupPosts[groupPostIndex].commentsCount ?? 0) + delta)
                .clamp(0, double.infinity)
                .toInt();
        groupsController.groupPosts.refresh();
      }
    }

    // Update in MyPostsController if registered
    if (Get.isRegistered<MyPostsController>()) {
      final myPostsController = Get.find<MyPostsController>();
      int myPostIndex =
          myPostsController.myPosts.value.result?.data?.indexWhere((p) => p.id == postIdInt) ?? -1;
      if (myPostIndex != -1) {
        myPostsController.myPosts.value.result!.data![myPostIndex].commentsCount =
            ((myPostsController.myPosts.value.result!.data![myPostIndex].commentsCount ?? 0) +
                    delta)
                .clamp(0, double.infinity)
                .toInt();
        myPostsController.myPosts.refresh();
      }
    }

    // Update in SavePostController if registered
    if (Get.isRegistered<SavePostController>()) {
      final savePostController = Get.find<SavePostController>();
      int savedPostIndex =
          savePostController.savePosts.value.result?.data?.indexWhere(
            (p) => p.post?.id == postIdInt,
          ) ??
          -1;
      if (savedPostIndex != -1) {
        savePostController.savePosts.value.result!.data![savedPostIndex].post?.commentsCount =
            ((savePostController
                            .savePosts
                            .value
                            .result!
                            .data![savedPostIndex]
                            .post
                            ?.commentsCount ??
                        0) +
                    delta)
                .clamp(0, double.infinity)
                .toInt();
        savePostController.savePosts.refresh();
      }
    }
  }

  void likePosts(BuildContext context) async {
    int postIndex =
        communityPosts.value.result?.data?.indexWhere((post) => post.id == selectedPostId.value) ??
        -1;

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
    int postIndex =
        communityPosts.value.result?.data?.indexWhere((post) => post.id == selectedPostId.value) ??
        -1;

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

  Future<void> getComments(String id) async {
    try {
      commentLoading(true);
      final response = await CommunityRep().getCommentsByPostId(id: id);
      comments(CommentsResponseModel.fromJson(response));
      commentsPage.value = comments.value.result?.meta?.currentPage ?? 1;
      commentsNextPageUrl.value = comments.value.result?.links?.next ?? "";
      debugPrint("comments response: ${comments.value.result?.data}");
    } catch (e) {
      commentLoading(false);
      debugPrint("Error fetching comments: $e");
    } finally {
      commentLoading(false);
    }
  }

  // pagination comments
  loadNextCommentsPage(String postId) async {
    if (isCommentsPaginating.value || commentsNextPageUrl.value.isEmpty) return;
    try {
      isCommentsPaginating(true);
      final response = await CommunityRep().getCommentsByPostId(
        id: postId,
        fullUrl: commentsNextPageUrl.value,
      );
      final newComments = CommentsResponseModel.fromJson(response);
      comments.value.result?.data?.addAll(newComments.result?.data ?? []);
      comments.refresh();
      commentsPage.value = newComments.result?.meta?.currentPage ?? 1;
      commentsNextPageUrl.value = newComments.result?.links?.next ?? "";
    } catch (e) {
      debugPrint("Error loading next comments page: $e");
    } finally {
      isCommentsPaginating(false);
    }
  }

  void likeCommentsAndSyncState(BuildContext context, int commentId, bool currentState) {
    // Make API call
    Map<String, dynamic> data = {"type": "App\\Models\\Comment", "id": commentId};
    CommunityRep().likePosts(data, context).then((response) {
      // If API call fails, revert UI
      if (response['success'] == false) {
        // Revert the like state for both comments and replies
        comments.update((val) {
          for (var comment in val?.result?.data ?? []) {
            if (comment.id == commentId) {
              comment.isLiked = currentState;
            } else {
              for (var reply in comment.replies ?? []) {
                if (reply.id == commentId) {
                  reply.isLiked = currentState;
                }
              }
            }
          }
        });
      }
      comments.refresh();
    });
  }

  createNewPosts({String? groupId}) async {
    File? selectedFile = selectedImage.value.isNotEmpty ? File(selectedImage.value) : null;
    // compress file
    File? compressFile;
    if (selectedFile != null) {
      compressFile = await compressImageTo2MB(selectedFile);
    }
    debugPrint("compress file length: ${compressFile?.lengthSync()}");

    final response = await CommunityRep().communityPosts(
      content: createPostController.text.trim(),
      topicId: selectedTopicId.value,
      imageFile: compressFile,
      videoUrl: videoLinkController.text.isNotEmpty ? videoLinkController.text : null,
      groupId: groupId, // Pass groupId to the repository
    );

    if (response['success'] == true) {
      getCommunityPosts();
      clearCreatePostData();
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
      if (editSelectedImage.value.isNotEmpty && !editSelectedImage.value.startsWith('http')) {
        selectedFile = File(editSelectedImage.value); // Only create a File object for local paths
        // compress file
        File? compressFile = await compressImageTo2MB(selectedFile);
        selectedFile = compressFile;
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
      debugPrint("Error updating post: $e");
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
      debugPrint("Error fetching post by ID: $e");
    } finally {
      isLoading(false);
    }
  }

  getTopic() async {
    try {
      isLoading(true);
      final response = await CommunityRep().getTopics();
      final topicsData = TopicsResponseModel.fromJson(response);
      topicsData.result?.data?.insert(0, topics_model.Topic(name: "All"));
      topics(topicsData);
      // selectedTopic.value = "All";
    } catch (e) {
      isLoading(false);
      debugPrint("Error fetching topics: $e");
    } finally {
      isLoading(false);
    }
  }

  void loadEditPostData(Posts post) {
    if (post.id != null) {
      // Set content, image, and video
      editPostController.text = post.content ?? '';
      editSelectedImage.value = post.image ?? '';
      editVideoController.text = post.videoUrl ?? '';

      // Set topic
      editSelectedTopic.value = post.topic?.name ?? '';
      editSelectedTopicId.value = post.topic?.id?.toString() ?? '';

      // Update the tab index
      selectedTabIndex.value = (post.videoUrl != null && post.videoUrl!.isNotEmpty) ? 1 : 0;
    } else {
      clearEditPostData();
    }
  }

  Future<void> deletePost(String postId, BuildContext context) async {
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
        context.pop();
      } else {
        debugPrint("Error deleting post: ${response['message']}");
      }
    } catch (e) {
      debugPrint("Error deleting post: $e");
    } finally {
      isLoading(false);
    } //
  }

  void clearCreatePostData() {
    createPostController.clear();
    videoLinkController.clear();
    selectedImage.value = "";
    selectedTabIndex.value = 0;
    selectedTopic.value = "";
  }

  void clearEditPostData() {
    editPostController.clear();
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
      debugPrint("Error updating group post state: $e");
    }

    // Update in MyPostsController if available
    try {
      if (Get.isRegistered<MyPostsController>()) {
        final myPostsController = Get.find<MyPostsController>();
        int myPostIndex =
            myPostsController.myPosts.value.result?.data?.indexWhere((p) => p.id == postId) ?? -1;
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
      debugPrint("MyPostsController not available: $e");
    }

    // Update in SavePostController if available
    try {
      if (Get.isRegistered<SavePostController>()) {
        final savePostController = Get.find<SavePostController>();
        int savedPostIndex =
            savePostController.savePosts.value.result?.data?.indexWhere((p) => p.id == postId) ??
            -1;
        if (savedPostIndex != -1) {
          if (action == 'like') {
            savePostController.savePosts.value.result!.data![savedPostIndex].post?.isLiked =
                newState;
          } else if (action == 'save') {
            savePostController.savePosts.value.result!.data![savedPostIndex].post?.isSaved =
                newState;
          }
          savePostController.savePosts.refresh();
        }
      }
    } catch (e) {
      // SavePostController might not be registered yet
      debugPrint("SavePostController not available: $e");
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

  void scrollToTop() {
    if (feedScrollController.hasClients) {
      feedScrollController.jumpTo(0);
    } else {
      debugPrint("ScrollController has no clients");
    }
  }

  void triggerPullToRefresh() {
    if (refreshKey.currentState != null) {
      refreshKey.currentState!.show();
    } else {
      debugPrint("RefreshIndicatorState is null");
    }
  }
}
