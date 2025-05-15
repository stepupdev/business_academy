import 'package:stepup_community/core/config/app_routes.dart';
import 'package:stepup_community/features/announcements/presentation/page/announcements_page.dart';
import 'package:stepup_community/features/community/presentation/pages/community_feed_page.dart';
import 'package:stepup_community/features/groups/presentation/pages/groups_page.dart';
import 'package:stepup_community/features/menu/controller/menu_controller.dart';
import 'package:stepup_community/features/menu/presentation/pages/menu_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;
  late final List<Widget> screens;

  // Define tab routes that match your router paths
  final List<String> tabRoutes = [
    AppRoutes.communityFeed,
    AppRoutes.groupsTab,
    AppRoutes.announcementsTab,
    AppRoutes.menuTab,
  ];

  @override
  void onInit() {
    super.onInit();

    // Find controllers only once
    final menuController = Get.find<UserMenuController>();

    // Initialize screens with PageStorageKey to help preserve state
    screens = [
      const CommunityFeedScreen(key: PageStorageKey('communityFeed')),
      const GroupsPage(key: PageStorageKey('groups')),
      const AnnouncementsPage(key: PageStorageKey('announcements')),
      const MenuPage(key: PageStorageKey('menu')),
    ];

    // Listen for tab changes to update resources
    ever(currentIndex, (index) {
      if (index == 3) {
        menuController.fetchCommunities();
        menuController.getUser();
      }
    });
  }

  Widget get currentScreen => screens[currentIndex.value];

  void changeTabIndex(int index, [BuildContext? context]) {
    if (currentIndex.value == index) return;

    currentIndex.value = index;

    // Update resources based on selected tab
    // if (index == 3) {
    //   final menuController = Get.find<UserMenuController>();
    //   menuController.fetchCommunities();
    //   menuController.getUser();
    // }

    // Navigate using GoRouter if context is provided
    if (context != null) {
      context.go(tabRoutes[index]);
    }
  }
}
