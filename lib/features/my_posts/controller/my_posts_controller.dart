import 'package:stepup_community/features/community/controller/community_controller.dart';
import 'package:stepup_community/features/my_posts/data/my_posts_model.dart';
import 'package:stepup_community/main.dart';
import 'package:stepup_community/repository/community_rep.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPostsController extends GetxController {
  var isLoading = false.obs;
  var myPosts = MyPostResponseModel().obs;

  final ScrollController scrollController = ScrollController();
  RxDouble scrollOffset = 0.0.obs;
  RxBool shouldRestorePosition = false.obs;

  // Pagination variables
  var currentPage = 1.obs;
  var nextPageUrl = ''.obs;
  var isPaginating = false.obs;

  @override
  void onInit() {
    getMyPosts();

    scrollController.addListener(() {
      scrollOffset.value = scrollController.offset;

      // Trigger pagination when nearing the bottom
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 300) {
        loadNextPage();
      }
    });

    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void saveScrollPosition() {
    if (scrollController.hasClients) {
      scrollOffset.value = scrollController.offset;
      shouldRestorePosition.value = true;
      debugPrint("MyPosts: Saved scroll position: ${scrollOffset.value}");
    }
  }

  void restoreScrollPosition() {
    if (shouldRestorePosition.value && scrollOffset.value > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (scrollController.hasClients) {
            try {
              scrollController.jumpTo(scrollOffset.value);
              debugPrint("MyPosts: Restored scroll position to: ${scrollOffset.value}");
            } catch (e) {
              debugPrint("MyPosts: Error restoring scroll position: $e");
            }
          }
        });
      });
    }
  }

  getMyPosts() async {
    try {
      isLoading(true);
      final response = await CommunityRep().getMyPosts();
      myPosts(MyPostResponseModel.fromJson(response));
      currentPage.value = myPosts.value.result?.meta?.currentPage ?? 1;
      nextPageUrl.value = myPosts.value.result?.links?.next ?? '';
    } catch (e) {
      isLoading(false);
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Error fetching my posts ${e.toString()}')),
      );
    } finally {
      isLoading(false);
    }
  }

  loadNextPage() async {
    if (isPaginating.value || nextPageUrl.value.isEmpty) return;
    try {
      isPaginating(true);
      final response = await CommunityRep().getMyPosts(fullUrl: nextPageUrl.value);
      final newPosts = MyPostResponseModel.fromJson(response);
      myPosts.value.result?.data?.addAll(newPosts.result?.data ?? []);
      currentPage.value = newPosts.result?.meta?.currentPage ?? 1;
      nextPageUrl.value = newPosts.result?.links?.next ?? "";
      myPosts.refresh();
    } catch (e) {
      debugPrint("Error loading next page: $e");
    } finally {
      isPaginating(false);
    }
  }

  void handlePostInteraction(int postId, String action, BuildContext context) async {
    final communityController = Get.find<CommunityController>();

    if (action == 'like') {
      int postIndex = myPosts.value.result?.data?.indexWhere((p) => p.id == postId) ?? -1;
      if (postIndex != -1) {
        bool currentState = myPosts.value.result!.data![postIndex].isLiked ?? false;
        myPosts.value.result!.data![postIndex].isLiked = !currentState;
        myPosts.refresh();
      }

      await communityController.processLike(context, postId);
    } else if (action == 'save') {
      int postIndex = myPosts.value.result?.data?.indexWhere((p) => p.id == postId) ?? -1;
      if (postIndex != -1) {
        bool currentState = myPosts.value.result!.data![postIndex].isSaved ?? false;
        myPosts.value.result!.data![postIndex].isSaved = !currentState;
        myPosts.refresh();
      }

      await communityController.processSave(context, postId);
    }
  }
}
