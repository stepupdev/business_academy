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
    try {
      var response = await CommunityRep().getUser();
      user(UserResponseModel.fromJson(response));
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  fetchCommunities() async {
    isLoading(true);
    try {
      var response = await CommunityRep().fetchCommunities();
      communities(CommunitiesResponseModel.fromJson(response));
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  changeCommunity(String id, BuildContext context) {
    isLoading(true);
    try {
      Map<String, dynamic> data = {"community_id": id};
      var response = CommunityRep().changeCommunity(data, context);
      print("response: $response");
      getUser();
      fetchCommunities();
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
