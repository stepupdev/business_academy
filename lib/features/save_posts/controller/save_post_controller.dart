import 'package:stepup_community/core/utils/app_strings.dart';
import 'package:stepup_community/core/utils/ui_support.dart';
import 'package:stepup_community/features/community/controller/community_controller.dart';
import 'package:stepup_community/features/save_posts/data/save_posts_res_model.dart';
import 'package:stepup_community/repository/community_rep.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavePostController extends GetxController {
  final isLoading = false.obs;
  final savePosts = SavePostResponseModel().obs;

  // Add ScrollController and position tracking variables
  final ScrollController scrollController = ScrollController();
  RxDouble scrollOffset = 0.0.obs;
  RxBool shouldRestorePosition = false.obs;

  // pagination
  var currentPage = 1.obs;
  var nextPageUrl = ''.obs;
  var isPaginating = false.obs;

  @override
  void onInit() {
    getSavePosts();

    // Add scroll listener to track position
    scrollController.addListener(() {
      scrollOffset.value = scrollController.offset;
    });

    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  // Method to save scroll position before navigation
  void saveScrollPosition() {
    if (scrollController.hasClients) {
      scrollOffset.value = scrollController.offset;
      shouldRestorePosition.value = true;
      debugPrint("SavePosts: Saved scroll position: ${scrollOffset.value}");
    }
  }

  // Method to restore scroll position when returning
  void restoreScrollPosition() {
    if (shouldRestorePosition.value && scrollOffset.value > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (scrollController.hasClients) {
            try {
              scrollController.jumpTo(scrollOffset.value);
              debugPrint("SavePosts: Restored scroll position to: ${scrollOffset.value}");
            } catch (e) {
              debugPrint("SavePosts: Error restoring scroll position: $e");
            }
          }
        });
      });
    }
  }

  getSavePosts() async {
    try {
      isLoading(true);
      final response = await CommunityRep().getSavePosts();
      if (response['message'] == 'Saved posts retrieved successfully') {
        savePosts(SavePostResponseModel.fromJson(response));
        currentPage.value = savePosts.value.result?.meta?.currentPage ?? 1;
        nextPageUrl.value = savePosts.value.result?.links?.next ?? '';
      }
    } catch (e) {
      debugPrint("Error fetching saved posts: $e");
    } finally {
      isLoading(false);
    }
  }

  loadNextPage() async {
    if (isPaginating.value || nextPageUrl.value.isEmpty) return;
    try {
      isPaginating(true);
      final response = await CommunityRep().getSavePosts(fullUrl: nextPageUrl.value);
      final newPosts = SavePostResponseModel.fromJson(response);
      savePosts.value.result?.data?.addAll(newPosts.result?.data ?? []);
      currentPage.value = newPosts.result?.meta?.currentPage ?? 1;
      nextPageUrl.value = newPosts.result?.links?.next ?? "";
      savePosts.refresh();
    } catch (e) {
      debugPrint("Error loading next page: $e");
    } finally {
      isPaginating(false);
    }
  }

  // Update the handlePostInteraction method:

  void handlePostInteraction(int postId, String action, BuildContext context) async {
    final communityController = Get.find<CommunityController>();

    if (action == 'like') {
      // Update UI optimistically
      debugPrint("Like action triggered for postId: $postId, action: $action");
      int postIndex = savePosts.value.result?.data?.indexWhere((p) => p.post?.id == postId) ?? -1;
      // find the post using the postId
      debugPrint("Post index found: $postIndex");
      if (postIndex != -1) {
        bool currentState = savePosts.value.result!.data![postIndex].post?.isLiked ?? false;
        savePosts.value.result!.data![postIndex].post?.isLiked = !currentState;
        savePosts.refresh();
      } else {
        Ui.showErrorSnackBar(context, message: AppStrings.error);
      }

      // Process the like action without making assumptions about post type
      await communityController.processLike(context, postId);
    } else if (action == 'save') {
      // Update UI optimistically
      int postIndex = savePosts.value.result?.data?.indexWhere((p) => p.post?.id == postId) ?? -1;
      if (postIndex != -1) {
        bool currentState = savePosts.value.result!.data![postIndex].post?.isSaved ?? false;
        savePosts.value.result!.data![postIndex].post?.isSaved = !currentState;
        savePosts.refresh();
      }

      // Process the save action without making assumptions about post type
      await communityController.processSave(context, postId);
    }
  }
}
