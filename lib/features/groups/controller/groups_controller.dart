import 'package:business_application/features/community/data/community_posts_model.dart';
import 'package:business_application/features/groups/data/groups_by_id_model.dart';
import 'package:business_application/features/groups/data/groups_models.dart';
import 'package:business_application/features/groups/data/groups_topic_response_model.dart';
import 'package:business_application/repository/community_rep.dart';
import 'package:business_application/repository/groups_rep.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupsController extends GetxController {
  var isLoading = false.obs;
  var groups = GroupsResponseModel().obs;
  var groupsDetails = GroupsByIdResponseModel().obs;
  var selectedPostId = 0.obs;
  var groupsTopicResponse = GroupsTopicResponseModel().obs;

  var selectedTopic = ''.obs;
  var filteredPosts = <Posts>[].obs;
  var groupPosts = <Posts>[].obs;
  var currentGroupId = ''.obs;

  @override
  void onInit() {
    fetchGroups();
    selectedTopic.listen((value) {
      if (value.isNotEmpty && value != "All") {
        filterPostsByTopic(value);
      } else {
        filteredPosts.assignAll(groups.value.result?.data?.cast<Posts>() ?? []);
      }
    });
    super.onInit();
  }

  fetchGroups() async {
    isLoading(true);
    try {
      var response = await GroupsRep().getGroups();
      groups(GroupsResponseModel.fromJson(response));
    } catch (e) {
    } finally {
      isLoading(false);
    }
  }

  Future<bool> fetchGroupsTopic(String id) async {
    try {
      var response = await GroupsRep().getGroupsTopic(id);
      groupsTopicResponse(GroupsTopicResponseModel.fromJson(response));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> fetchGroupsDetails(String id) async {
    try {
      var response = await GroupsRep().getGroupsDetails(id);
      groupsDetails(GroupsByIdResponseModel.fromJson(response));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> fetchGroupPosts(String groupId) async {
    try {
      isLoading(true);
      print("Fetching posts for group: $groupId");

      if (groupId.isEmpty) {
        print("Group ID is empty!");
        return false;
      }

      final response = await CommunityRep().getCommunityPosts(params: {'group_id': groupId});
      print("Group posts response: $response");

      final postsModel = PostsResponseModel.fromJson(response);
      groupPosts.assignAll(postsModel.result?.data ?? []);
      print("Loaded ${groupPosts.length} posts for group $groupId"); // Debug line
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading(false);
    }
  }

  void filterPostsByTopic(String topicName, {String? topicId}) async {
    if (topicName == "All") {
      // Remove topic_id parameter to fetch all posts for the group
      try {
        isLoading(true);
        final response = await CommunityRep().getCommunityPosts(params: {'group_id': currentGroupId.value});
        groupPosts.assignAll(PostsResponseModel.fromJson(response).result?.data ?? []);
      } catch (e) {
        print("Error fetching all group posts: $e");
      } finally {
        isLoading(false);
      }
    } else {
      try {
        isLoading(true);
        final response = await CommunityRep().getCommunityPosts(
          params: {'topic_id': topicId, 'group_id': currentGroupId.value},
        );
        groupPosts.assignAll(PostsResponseModel.fromJson(response).result?.data ?? []);
      } catch (e) {
        print("Error fetching group posts by topic: $e");
      } finally {
        isLoading(false);
      }
    }
  }

  likePosts(BuildContext context) async {
    int postIndex = groupPosts.indexWhere((post) => post.id == selectedPostId.value);

    if (postIndex == -1) return;

    bool previousState = groupPosts[postIndex].isLiked ?? false;

    // Update the UI immediately
    groupPosts[postIndex].isLiked = !previousState;
    groupPosts.refresh();

    int filteredIndex = filteredPosts.indexWhere((post) => post.id == selectedPostId.value);
    if (filteredIndex != -1) {
      filteredPosts[filteredIndex].isLiked = !previousState;
      filteredPosts.refresh();
    }

    // Send the like request to the server
    Map<String, dynamic> data = {"type": "App\\Models\\Post", "id": selectedPostId.value};
    final response = await CommunityRep().likePosts(data, context);

    // Revert the state if the server request fails
    if (response['success'] == false) {
      groupPosts[postIndex].isLiked = previousState;
      groupPosts.refresh();

      if (filteredIndex != -1) {
        filteredPosts[filteredIndex].isLiked = previousState;
        filteredPosts.refresh();
      }
    }
  }

  void saveGroupPosts(BuildContext context) async {
    int postIndex = groupPosts.indexWhere((post) => post.id == selectedPostId.value);

    if (postIndex == -1) return;

    bool previousState = groupPosts[postIndex].isSaved ?? false;

    // Update the UI immediately
    groupPosts[postIndex].isSaved = !previousState;
    groupPosts.refresh();

    int filteredIndex = filteredPosts.indexWhere((post) => post.id == selectedPostId.value);
    if (filteredIndex != -1) {
      filteredPosts[filteredIndex].isSaved = !previousState;
      filteredPosts.refresh();
    }

    // Send the like request to the server
    Map<String, dynamic> data = {"type": "App\\Models\\Post", "id": selectedPostId.value};
    final response = await CommunityRep().savePost(data, context);

    // Revert the state if the server request fails
    if (response['success'] == false) {
      groupPosts[postIndex].isSaved = previousState;
      groupPosts.refresh();

      if (filteredIndex != -1) {
        filteredPosts[filteredIndex].isSaved = previousState;
        filteredPosts.refresh();
      }
    }
  }
}
