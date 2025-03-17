import 'package:business_application/core/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:business_application/features/home/controller/home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          body: controller.currentScreen,
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: controller.currentIndex,
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.grey,
            selectedItemColor: AppColors.primaryColor,
            showUnselectedLabels: true,
            onTap: controller.changeTabIndex,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.people_outline_outlined), label: 'Community'),
              BottomNavigationBarItem(icon: Icon(Icons.topic_outlined), label: 'Topics'),
              BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Feed'),
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
            ],
          ),
        );
      },
    );
  }
}
