import 'package:business_application/features/announcements/presentation/page/announcements_page.dart';
import 'package:business_application/features/community/controller/community_controller.dart';
import 'package:business_application/features/menu/controller/menu_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:business_application/features/community/presentation/pages/community_feed_page.dart';
import 'package:business_application/features/groups/presentation/pages/groups_page.dart';
import 'package:business_application/features/menu/presentation/pages/menu_page.dart';

class HomeController extends GetxController {
  var currentIndex = 0;
  var communityController = Get.find<CommunityController>();
  var menuController = Get.find<UserMenuController>();

  final List<Widget> screens = [CommunityFeedScreen(), const GroupsPage(), const AnnouncementsPage(), const MenuPage()];

  Widget get currentScreen => screens[currentIndex];

  void changeTabIndex(int index) {
    currentIndex = index;
    if (index == 0) {
      communityController.getCommunityPosts();
      communityController.getTopic();
    } else if (index == 3) {
      menuController.fetchCommunities();
      menuController.getUser();
    }
    update();
  }
}
