import 'package:business_application/features/my_posts/data/my_posts_model.dart';
import 'package:business_application/main.dart';
import 'package:business_application/repository/community_rep.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPostsController extends GetxController {
  var isLoading = false.obs;
  var myPosts = MyPostResponseModel().obs;

  // Add ScrollController and position tracking variables
  final ScrollController scrollController = ScrollController();
  RxDouble scrollOffset = 0.0.obs;
  RxBool shouldRestorePosition = false.obs;

  @override
  void onInit() {
    getMyPosts();

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
      print("MyPosts: Saved scroll position: ${scrollOffset.value}");
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
              print("MyPosts: Restored scroll position to: ${scrollOffset.value}");
            } catch (e) {
              print("MyPosts: Error restoring scroll position: $e");
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
    } catch (e) {
      isLoading(false);
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Error fetching my posts ${e.toString()}')),
      );
    } finally {
      isLoading(false);
    }
  }
}
