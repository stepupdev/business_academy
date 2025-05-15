import 'package:stepup_community/data/posts/posts_models.dart';
import 'package:stepup_community/features/announcements/data/announcements_data.dart';
import 'package:stepup_community/repository/community_rep.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnnouncementController extends GetxController {
  var isLoading = false.obs;
  var announcements = AnnouncementPostResponseModel().obs;
  var announcementPosts = <Posts>[].obs;
  var selectedPostId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAnnouncements();
  }

  Future<bool> fetchAnnouncements() async {
    isLoading.value = true;
    try {
      final response = await CommunityRep().fetchAnnouncements();
      if (response != null) {
        announcements.value = AnnouncementPostResponseModel.fromJson(response);
        announcementPosts.value = announcements.value.result?.data ?? [];
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Error fetching announcements: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  likePosts(BuildContext context) async {
    int postIndex = announcementPosts.indexWhere((post) => post.id == selectedPostId.value);
    debugPrint("postindex $postIndex");
    debugPrint("selectedPostId ${selectedPostId.value}");
    debugPrint("announcementPosts ${announcementPosts[postIndex].id}");

    if (postIndex == -1) return;

    bool previousState = announcementPosts[postIndex].isLiked ?? false;

    // Update the UI immediately
    announcementPosts[postIndex].isLiked = !previousState;
    announcements.refresh();

    // int filteredIndex = filteredPosts.indexWhere((post) => post.id == selectedPostId.value);
    // if (filteredIndex != -1) {
    //   filteredPosts[filteredIndex].isLiked = !previousState;
    //   filteredPosts.refresh();
    // }

    // Send the like request to the server
    Map<String, dynamic> data = {"type": "App\\Models\\Post", "id": selectedPostId.value};
    final response = await CommunityRep().likePosts(data, context);

    // Revert the state if the server request fails
    if (response['success'] == false) {
      announcementPosts[postIndex].isLiked = previousState;
      announcementPosts.refresh();

      // if (filteredIndex != -1) {
      //   filteredPosts[filteredIndex].isLiked = previousState;
      //   filteredPosts.refresh();
      // }
    }
  }

  void saveGroupPosts(BuildContext context) async {
    int postIndex = announcementPosts.indexWhere((post) => post.id == selectedPostId.value);

    if (postIndex == -1) return;

    bool previousState = announcementPosts[postIndex].isSaved ?? false;

    // Update the UI immediately
    announcementPosts[postIndex].isSaved = !previousState;
    announcements.refresh();

    // int filteredIndex = filteredPosts.indexWhere((post) => post.id == selectedPostId.value);
    // if (filteredIndex != -1) {
    //   filteredPosts[filteredIndex].isSaved = !previousState;
    //   filteredPosts.refresh();
    // }

    // Send the save request to the server
    Map<String, dynamic> data = {"post_id": selectedPostId.value}; // CHANGE THIS LINE - was using wrong format
    final response = await CommunityRep().savePost(data, context);

    // Revert the state if the server request fails
    if (response['success'] == false) {
      announcementPosts[postIndex].isSaved = previousState;
      announcements.refresh();

      // if (filteredIndex != -1) {
      //   filteredPosts[filteredIndex].isSaved = previousState;
      //   filteredPosts.refresh();
      // }
    }
  }
}
