import 'package:business_application/features/menu/data/communities_response_model.dart';
import 'package:business_application/features/menu/data/user_response_model.dart';
import 'package:business_application/repository/community_rep.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserMenuController extends GetxController {
  var isLoading = false.obs;

  var user = UserResponseModel().obs;

  var communities = CommunitiesResponseModel().obs;

  @override
  void onReady() {
    getUser();
    fetchCommunities();
    super.onReady();
  }

  @override
  void onInit() {
    getUser();
    fetchCommunities();
    super.onInit();
  }

  getUser() async {
    isLoading(true);
    var response = await CommunityRep().getUser();
    user(UserResponseModel.fromJson(response));
    isLoading(false);
  }

  fetchCommunities() async {
    isLoading(true);
    var response = await CommunityRep().fetchCommunities();
    communities(CommunitiesResponseModel.fromJson(response));
    debugPrint("Error fetching communities ");
    isLoading(false);
  }

  Future<void> changeCommunity(String id, BuildContext context) async {
    isLoading(true);
    Map<String, dynamic> data = {"community_id": id};
    var response = CommunityRep().changeCommunity(data, context);
    debugPrint("response: $response");
    getUser();
    fetchCommunities();
    debugPrint("Error changing community");
    isLoading(false);
  }
}
