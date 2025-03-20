import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_routes.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class UserPostWidget extends StatelessWidget {
  const UserPostWidget({
    super.key,
    required this.name,
    required this.rank,
    required this.topic,
    required this.time,
    required this.postImage,
    required this.dp,
    required this.caption,
    required this.commentCount,
  });

  final String name;
  final String rank;
  final String topic;
  final String time;
  final String postImage;
  final String dp;
  final String caption;
  final String commentCount;

  @override
  Widget build(BuildContext context) {
    final dark = Ui.isDarkMode(context);
    return GestureDetector(
      onTap: () {
        context.push(AppRoutes.postDetails); // Navigate to post details page
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
        color: dark ? AppColors.dark : Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(backgroundImage: NetworkImage(dp)),
                10.wS,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                        5.wS,
                        Container(
                          margin: EdgeInsets.only(left: 5.w),
                          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withAlpha(200),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(rank, style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 10.sp)),
                        ),
                      ],
                    ),
                    Text(time, style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
                  ],
                ),
                10.wS,
                Text(
                  topic == "All" ? "Social" : topic, // Replace with the selected topic
                  style: GoogleFonts.plusJakartaSans(color: Colors.grey),
                ),
              ],
            ),
            15.hS,
            Text(caption),
            15.hS,
            SizedBox(height: 200.h, child: Image.asset(postImage, fit: BoxFit.cover)),
            15.hS,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.favorite_border, color: dark ? AppColors.darkGrey : AppColors.dark),
                Row(
                  children: [
                    SvgPicture.asset("assets/icons/comment.svg", color: dark ? AppColors.darkGrey : AppColors.dark),
                    5.wS,
                    Text(commentCount, style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
                  ],
                ),
                Icon(Icons.bookmark_outline, color: Colors.amber, size: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
