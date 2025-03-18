import 'package:business_application/core/config/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Notifications',
          style: GoogleFonts.plusJakartaSans(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 18.sp),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: HeroIcon(HeroIcons.cog6Tooth, color: Colors.black87),
            onPressed: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(100.w, 80.h, 0, 0),
                items: [
                  PopupMenuItem(child: Text('Settings'), value: 'settings'),
                  PopupMenuItem(child: Text('Logout'), value: 'logout'),
                ],
              ).then((value) {
                if (value == 'settings') {
                  // Navigate to settings page
                } else if (value == 'logout') {
                  // Logout logic
                }
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          children: [
            NotificationCard(
              time: '10:30 AM',
              title: 'Welcome to the community!',
              message: 'We are excited to have you here. Feel free to ask any questions.',
            ),
            NotificationCard(
              time: '9:00 AM',
              title: 'Task Deadline',
              message: 'Submit the project report by 5:00 PM today.',
            ),
            // Add more NotificationCard widgets as needed
          ],
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String time;
  final String title;
  final String message;

  const NotificationCard({super.key, required this.time, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 25.r, child: SvgPicture.asset('assets/logo/logo.svg', width: 30.0, height: 30.0)),
          10.wS,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10.0,
                      height: 10.0,
                      decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                    ),
                    10.wS,
                    Text(time, style: TextStyle(fontSize: 12.0, color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 8.0),
                Text(title, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                SizedBox(height: 8.0),
                Text(message, style: TextStyle(fontSize: 14.0, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
