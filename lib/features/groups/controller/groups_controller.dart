import 'package:business_application/core/utils/ui_support.dart';
import 'package:business_application/features/community/data/community_posts_model.dart';
import 'package:business_application/features/groups/data/group_post_model.dart';
import 'package:business_application/features/groups/data/groups_by_id_model.dart';
import 'package:business_application/features/groups/data/groups_models.dart';
import 'package:business_application/features/groups/data/groups_topic_response_model.dart';
import 'package:business_application/repository/community_rep.dart';
import 'package:business_application/repository/groups_rep.dart';
import 'package:get/get.dart';

class GroupsController extends GetxController {
  var isLoading = false.obs;
  var groups = GroupsResponseModel().obs;
  var groupsDetails = GroupsByIdResponseModel().obs;
  var groupsTopicResponse = GroupsTopicResponseModel().obs;

  var selectedTopic = ''.obs;
  var filteredPosts = <GroupPost>[].obs; // Observable for filtered posts
  var groupPosts = <Posts>[].obs; // Observable for group-specific posts
  var currentGroupId = ''.obs; // Track the currently selected group ID

  @override
  void onInit() {
    fetchGroups();
    selectedTopic.listen((value) {
      if (value.isNotEmpty && value != "All") {
        filterPostsByTopic(value); // Filter posts locally
      } else {
        filteredPosts.assignAll(
          (groups.value.result?.data as List<GroupPost>?) ?? [],
        ); // Show all posts if "All" is selected
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
      print(e);
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
      print("Error fetching group topics: $e");
      return false;
    }
  }

  Future<bool> fetchGroupsDetails(String id) async {
    try {
      var response = await GroupsRep().getGroupsDetails(id);
      groupsDetails(GroupsByIdResponseModel.fromJson(response));
      return true;
    } catch (e) {
      print("Error fetching group details: $e");
      return false;
    }
  }

  Future<bool> fetchGroupPosts(String groupId) async {
    try {
      isLoading(true);
      print("Fetching posts for group: $groupId"); // Debug line

      // Verify the parameter is valid and non-empty
      if (groupId.isEmpty) {
        print("Group ID is empty!");
        return false;
      }

      final response = await CommunityRep().getCommunityPosts(params: {'group_id': groupId});
      print("Group posts response: $response"); // Debug line

      final postsModel = PostsResponseModel.fromJson(response);
      groupPosts.assignAll(postsModel.result?.data ?? []);

      print("Loaded ${groupPosts.length} posts for group $groupId"); // Debug line
      return true;
    } catch (e) {
      print("Error fetching group posts: $e");
      Ui.errorSnackBar(message: 'Failed to fetch group posts');
      return false;
    } finally {
      isLoading(false);
    }
  }

  void filterPostsByTopic(String topicName) {
    final allPosts = groups.value.result?.data ?? [];
    if (topicName == "All") {
      filteredPosts.assignAll(allPosts as Iterable<GroupPost>); // Show all posts for "All" topic
    } else {
      filteredPosts.assignAll((allPosts as List<GroupPost>).where((post) => post.topic?.name == topicName).toList());
    }
  }
}
