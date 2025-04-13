import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/services/connectivity_service.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:business_application/features/no_internet/presentation/pages/no_internet_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:business_application/features/home/controller/home_controller.dart';
import 'package:heroicons/heroicons.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.child});
  final Widget? child;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(HomeController()); // Initialize once
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Sync the current navigation state with the bottom tab index
    final location = GoRouterState.of(context).location;
    for (int i = 0; i < controller.tabRoutes.length; i++) {
      if (location == controller.tabRoutes[i]) {
        controller.currentIndex.value = i;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Ui.isDarkMode(context);

    return WillPopScope(
      onWillPop: () async {
        if (controller.currentIndex.value != 0) {
          controller.changeTabIndex(0, context); // Pass context for navigation
          return false;
        } else {
          final exitApp = await _showExitDialog(context);
          if (exitApp) {
            SystemNavigator.pop();
          }
          return false;
        }
      },
      child: Obx(() {
        final isConnect = Get.find<ConnectivityService>().isConnected.value;
        return Scaffold(
          body: isConnect ? widget.child : const NoInternetPage(),
          bottomNavigationBar:
              isConnect
                  ? Obx(
                    () => BottomNavigationBar(
                      backgroundColor: dark ? AppColors.dark : Colors.white,
                      currentIndex: controller.currentIndex.value,
                      type: BottomNavigationBarType.fixed,
                      unselectedItemColor: dark ? Colors.white : Colors.grey,
                      selectedItemColor: AppColors.primaryColor,
                      showUnselectedLabels: true,
                      onTap: (index) => controller.changeTabIndex(index, context), // Pass context for navigation
                      items: const [
                        BottomNavigationBarItem(icon: HeroIcon(HeroIcons.home), label: 'Home'),
                        BottomNavigationBarItem(icon: HeroIcon(HeroIcons.users), label: 'Groups'),
                        BottomNavigationBarItem(icon: HeroIcon(HeroIcons.megaphone), label: 'Announcements'),
                        BottomNavigationBarItem(icon: HeroIcon(HeroIcons.bars3), label: 'Menu'),
                      ],
                    ),
                  )
                  : null,
        );
      }),
    );
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    final dark = Ui.isDarkMode(context);
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: dark ? AppColors.dark : AppColors.light,
                    borderRadius: BorderRadius.circular(20),
                  ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
