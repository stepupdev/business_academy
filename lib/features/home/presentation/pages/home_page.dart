import 'package:business_application/core/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:business_application/features/home/controller/home_controller.dart';
import 'package:heroicons/heroicons.dart';
import 'package:flutter/services.dart'; // Required for SystemNavigator.pop()

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return PopScope(
          canPop: controller.currentIndex != 0, // Allow back press if not on home tab
          onPopInvoked: (didPop) async {
            if (!didPop && controller.currentIndex == 0) {
              bool exitApp = await _showExitDialog(context);
              if (exitApp) {
                SystemNavigator.pop(); // Properly closes the app
              }
            }
          },
          child: Scaffold(
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
          ),
        );
      },
    );
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning_amber_rounded, color: AppColors.primaryColor, size: 50),
                      const SizedBox(height: 20),
                      const Text('Close App', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      const Text(
                        'Are you sure you want to close the app?',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(false); // Return false (don't exit)
                            },
                            child: const Text('No', style: TextStyle(color: Colors.black)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(true); // Return true (exit app)
                            },
                            child: const Text('Yes', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        ) ??
        false; // If dialog is dismissed, default to false
  }
}
