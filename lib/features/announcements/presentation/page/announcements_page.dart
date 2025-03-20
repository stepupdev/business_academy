import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/core/services/auth_services.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:business_application/widgets/custom_post_cart_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Ui.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Announcements')),
      body: ListView.separated(
        separatorBuilder: (context, index) => Container(height: 3.h, color: dark ? Colors.black : Colors.grey[200]),
        itemCount: 11, // Increased by 1 to include the create post section
        itemBuilder: (context, index) {
          return UserPostWidget(
            name: 'Fahmid Al Nayem',
            rank: 'Rank $index',
            topic: "Social Media",
            time: '2 hours ago',
            postImage: 'assets/images/stepup_image.png',
            dp: Get.find<AuthService>().currentUser.value.result?.user?.avatar ?? "",
            caption: 'This is the caption for post $index',
            commentCount: '12',
          );
        },
      ),
    );
  }
}
