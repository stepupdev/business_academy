import 'package:business_application/features/my_posts/data/my_posts_model.dart';
import 'package:business_application/main.dart';
import 'package:business_application/repository/community_rep.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPostsController extends GetxController {
  var isLoading = false.obs;
  var myPosts = MyPostResponseModel().obs;

  @override
  void onInit() {
    getMyPosts();
    super.onInit();
  }

  getMyPosts() async {
    try {
      isLoading(true);
      final response = await CommunityRep().getMyPosts();
      myPosts(MyPostResponseModel.fromJson(response));
      scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(content: Text('My posts fetched successfully')));
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
