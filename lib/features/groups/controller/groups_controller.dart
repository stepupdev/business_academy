import 'package:business_application/features/groups/data/group_post_model.dart';
import 'package:business_application/features/groups/data/groups_by_id_model.dart';
import 'package:business_application/features/groups/data/groups_models.dart';
import 'package:business_application/features/groups/data/groups_topic_response_model.dart';
import 'package:business_application/repository/groups_rep.dart';
import 'package:get/get.dart';

class GroupsController extends GetxController {
  var isLoading = false.obs;
  var groups = GroupsResponseModel().obs;
  var groupsDetails = GroupsByIdResponseModel().obs;
  var groupsTopicResponse = GroupsTopicResponseModel().obs;

  var selectedTopic = ''.obs;
  var filteredPosts = <GroupPost>[].obs; // Observable for filtered posts

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

  fetchGroupsTopic(String id) async {
    isLoading(true);
    try {
      var response = await GroupsRep().getGroupsTopic(id);
      groupsTopicResponse(GroupsTopicResponseModel.fromJson(response));
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  fetchGroupsDetails(String id) async {
    isLoading(true);
    try {
      var response = await GroupsRep().getGroupsDetails(id);
      groupsDetails(GroupsByIdResponseModel.fromJson(response));
    } catch (e) {
      print(e);
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
