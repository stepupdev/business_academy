import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:business_application/features/home/presentation/controllers/home_controller.dart';

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
            currentIndex: controller.currentIndex,
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.grey,
            selectedItemColor: Color(0xFF6200EE),
            showUnselectedLabels: true,
            onTap: controller.changeTabIndex,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.people_outline_outlined), label: 'Community'),
              BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notification'),
              BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Feed'),
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
            ],
          ),
        );
      },
    );
  }
}

class PostCard extends StatelessWidget {
  final GoogleSignInAccount? user;
  final String content;

  const PostCard({super.key, required this.user, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(title: Text(user?.email ?? 'Anonymous'), subtitle: Text(content)),
          ButtonBar(
            children: [
              TextButton(onPressed: () {}, child: const Text('Like')),
              TextButton(onPressed: () {}, child: const Text('Comment')),
            ],
          ),
        ],
      ),
    );
  }
}
