import 'package:business_application/core/utils/ui_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Ui.isDarkMode(context);
    return Scaffold(
      // appBar: AppBar(title: const Text('Announcements')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 100.sp, color: dark ? Colors.orangeAccent : Colors.blueAccent),
            SizedBox(height: 20.h),
            Text(
              "Announcements Coming Soon",
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: dark ? Colors.white : Colors.black),
            ),
            SizedBox(height: 10.h),
            Text(
              "Stay tuned! The announcements feature will be published soon.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, color: dark ? Colors.grey[400] : Colors.grey[700]),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
