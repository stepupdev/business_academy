import 'package:business_application/features/community/controller/community_controller.dart';
import 'package:business_application/features/groups/controller/groups_controller.dart';
import 'package:business_application/features/save_posts/data/save_posts_res_model.dart';
import 'package:business_application/repository/community_rep.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavePostController extends GetxController {
  final isLoading = false.obs;
  final savePosts = SavePostResponseModel().obs;

  // Add ScrollController and position tracking variables
  final ScrollController scrollController = ScrollController();
  RxDouble scrollOffset = 0.0.obs;
  RxBool shouldRestorePosition = false.obs;

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
      print("SavePosts: Saved scroll position: ${scrollOffset.value}");
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
              print("SavePosts: Restored scroll position to: ${scrollOffset.value}");
            } catch (e) {
              print("SavePosts: Error restoring scroll position: $e");
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
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  // Update the handlePostInteraction method:

  void handlePostInteraction(int postId, String action, BuildContext context) async {
    final communityController = Get.find<CommunityController>();

    if (action == 'like') {
      // Update UI optimistically
      int postIndex = savePosts.value.result?.data?.indexWhere((p) => p.id == postId) ?? -1;
      if (postIndex != -1) {
        bool currentState = savePosts.value.result!.data![postIndex].isLiked ?? false;
        savePosts.value.result!.data![postIndex].isLiked = !currentState;
        savePosts.refresh();
      }

      // Process the like action without making assumptions about post type
      await communityController.processLike(context, postId);
    } else if (action == 'save') {
      // Update UI optimistically
      int postIndex = savePosts.value.result?.data?.indexWhere((p) => p.id == postId) ?? -1;
      if (postIndex != -1) {
        bool currentState = savePosts.value.result!.data![postIndex].isSaved ?? false;
        savePosts.value.result!.data![postIndex].isSaved = !currentState;
        savePosts.refresh();
      }

      // Process the save action without making assumptions about post type
      await communityController.processSave(context, postId);
    }
  }
}
