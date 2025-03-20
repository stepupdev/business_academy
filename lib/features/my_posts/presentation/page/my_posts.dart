import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MyPostsPage extends StatelessWidget {
  const MyPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Ui.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(title: Text('My Posts')),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
            color: dark ? AppColors.dark : Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(child: Text('U$index')),
                    10.wS,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fahmid Al Nayem', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                        Text('2 hours ago', style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
                      ],
                    ),
                    10.wS,
                    Text('Social Media', style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
                  ],
                ),
                15.hS,
                Text('This is the caption for post $index'),
                15.hS,
                SizedBox(height: 200.h, child: Image.asset("assets/images/stepup_image.png", fit: BoxFit.cover)),
                15.hS,
                Row(
                  children: [
                    Icon(Icons.favorite_border),
                    15.wS,
                    SvgPicture.asset("assets/icons/comment.svg", color: dark ? AppColors.light : Colors.black),
                    5.wS,
                    Text('12', style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
                    const Spacer(),
                    Icon(Icons.bookmark_outline, color: Colors.amber, size: 24),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
