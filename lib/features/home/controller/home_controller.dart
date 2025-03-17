import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:business_application/features/community/presentation/pages/community_feed_page.dart';
import 'package:business_application/features/notification/presentation/pages/notification_page.dart';
import 'package:business_application/features/feed/presentation/pages/feed_page.dart';
import 'package:business_application/features/menu/presentation/pages/menu_page.dart';

class HomeController extends GetxController {
  var currentIndex = 0;

  final List<Widget> screens = [
    const CommunityFeedScreen(),
    const NotificationPage(),
    const FeedPage(),
    const MenuPage(),
  ];

  Widget get currentScreen => screens[currentIndex];

  void changeTabIndex(int index) {
    currentIndex = index;
    update();
  }
}
