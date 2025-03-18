import 'package:business_application/core/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:business_application/features/home/controller/home_controller.dart';
import 'package:heroicons/heroicons.dart';

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
              BottomNavigationBarItem(icon: HeroIcon(HeroIcons.home), label: 'Home'),
              BottomNavigationBarItem(icon: HeroIcon(HeroIcons.users), label: 'Groups'),
              BottomNavigationBarItem(icon: HeroIcon(HeroIcons.bars3), label: 'Menu'),
            ],
          ),
        );
      },
    );
  }
}
