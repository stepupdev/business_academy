import 'package:business_application/features/auth/controller/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), automaticallyImplyLeading: true, backgroundColor: Colors.white),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFDEF3FF)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(radius: 50, backgroundImage: NetworkImage(authController.userPhoto.value)),
              SizedBox(height: 10),
              Text(authController.userDisplayName.value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(height: 10),
              Text(authController.userEmail.value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Icon(Icons.play_circle_outline),
                      title: Text('My Courses'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Handle My Courses action
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.favorite_border_outlined),
                      title: Text('Bookmark'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Handle Bookmark action
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.help_outline),
                      title: Text('Help & Feedback'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Handle Help & Feedback action
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      authController.signOut();
                    },
                    icon: Icon(Icons.logout, color: Colors.black, size: 20),
                    label: Text(
                      'Logout',
                      style: GoogleFonts.plusJakartaSans(color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                "Version 1.0.0",
                style: GoogleFonts.lexend(fontSize: 14, color: Color(0xffA1A3AD), fontWeight: FontWeight.w700),
              ),
              Text(
                "© 2025 StepUp. All rights reserved",
                style: GoogleFonts.lexend(fontSize: 14, color: Color(0xffA1A3AD)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
