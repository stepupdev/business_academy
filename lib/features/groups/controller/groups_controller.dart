import 'package:business_application/features/community/data/community_posts_model.dart';
import 'package:business_application/features/groups/data/groups_by_id_model.dart';
import 'package:business_application/features/groups/data/groups_models.dart';
import 'package:business_application/features/groups/data/groups_topic_response_model.dart' as groups_topic;
import 'package:business_application/repository/community_rep.dart';
import 'package:business_application/repository/groups_rep.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupsController extends GetxController {
  var isLoading = false.obs;
  var groups = GroupsResponseModel().obs;
  var groupsDetails = GroupsByIdResponseModel().obs;
  var selectedPostId = 0.obs;
  var groupsTopicResponse = groups_topic.GroupsTopicResponseModel().obs;

  var selectedTopic = ''.obs;
  var filteredPosts = <Posts>[].obs;
  var groupPosts = <Posts>[].obs;
  var currentGroupId = ''.obs;

  var currentPage = 1.obs;
  var nextPageUrl = ''.obs;
  var isPaginating = false.obs;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    fetchGroups();
    selectedTopic.listen((value) {
      if (value.isNotEmpty) {
        final gropTopic = groupsTopicResponse.value.result?.data?.firstWhere(
          (topic) => topic.name == value,
          orElse: () => groups_topic.GroupTopics(),
        );
        filterPostsByTopic(value, topicId: gropTopic?.id.toString());
      }
    });

    // Add scroll listener for pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 300) {
        loadNextPage();
      }
    });

    super.onInit();
  }

  fetchGroups() async {
    isLoading(true);
    try {
      var response = await GroupsRep().getGroups();
      groups(GroupsResponseModel.fromJson(response));
    } finally {
      isLoading(false);
    }
  }

  Future<bool> fetchGroupsTopic(String id) async {
    try {
      var response = await GroupsRep().getGroupsTopic(id);
      groupsTopicResponse(groups_topic.GroupsTopicResponseModel.fromJson(response));
      groupsTopicResponse.value.result?.data?.insert(0, groups_topic.GroupTopics(id: 0, name: "All"));
      selectedTopic.value = "All";
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
      debugPrint("Fetching posts for group: $groupId");

      if (groupId.isEmpty) {
        debugPrint("Group ID is empty!");
        return false;
      }

      final response = await CommunityRep().getCommunityPosts(params: {'group_id': groupId});
      debugPrint("Group posts response: $response");

      final postsModel = PostsResponseModel.fromJson(response);
      groupPosts.assignAll(postsModel.result?.data ?? []);
      debugPrint("Loaded ${groupPosts.length} posts for group $groupId"); // Debug line
      currentPage.value = postsModel.result?.meta?.currentPage ?? 1;
      nextPageUrl.value = postsModel.result?.links?.next ?? '';
      return true;
    } catch (e) {
      return false;
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
      groupPosts.addAll(newPosts.result?.data ?? []);
      currentPage.value = newPosts.result?.meta?.currentPage ?? 1;
      nextPageUrl.value = newPosts.result?.links?.next ?? "";
      groupPosts.refresh();
    } catch (e) {
      debugPrint("Error loading next page: $e");
    } finally {
      isPaginating(false);
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
        debugPrint("Error fetching all group posts: $e");
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
        debugPrint("Error fetching group posts by topic: $e");
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

    // Send the save request to the server
    Map<String, dynamic> data = {"post_id": selectedPostId.value}; // CHANGE THIS LINE - was using wrong format
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
