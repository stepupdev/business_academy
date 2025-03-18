// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_routes.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CommunityFeedScreen extends StatelessWidget {
  CommunityFeedScreen({super.key});

  final List<Map<String, dynamic>> topics = [
    {'name': 'All', 'count': null},
    {'name': 'Social Media', 'count': 5},
    {'name': 'StepUp', 'count': 3},
    {'name': 'Education', 'count': 4},
    {'name': 'Courses', 'count': 2},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor, Color(0xFF003BC6)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(24.h),
          child: Container(color: Colors.grey[300], height: 1.h),
        ),
        title: Row(
          children: [
            SvgPicture.asset("assets/logo/bg_logo.svg"),
            10.wS,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('StepUp', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                Text('Community', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
        actionsPadding: EdgeInsets.only(right: 10.w),

        actions: [
          CircleAvatar(
            backgroundColor: Color(0xff2F60CF),
            child: IconButton(
              icon: Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () {
                context.push(AppRoutes.notification);
              },
            ),
          ),
          10.wS,
          CircleAvatar(
            backgroundColor: Color(0xff2F60CF),
            child: IconButton(icon: Icon(Icons.search, color: Colors.white), onPressed: () {}),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Color(0xffE9F0FF),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          Get.find<AuthService>().currentUser.value.result?.user?.avatar ?? "",
                        ),
                      ),
                      10.wS,
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            context.push('/create-post');
                          },
                          style: TextButton.styleFrom(
                            alignment: Alignment.centerLeft,
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                            side: BorderSide(color: Colors.blue.shade100),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          ),
                          child: Text(
                            'Creatre a Post!',
                            style: GoogleFonts.plusJakartaSans(color: Colors.grey, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              12.hS,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  height: 25.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => SizedBox(width: 5.w),
                    itemCount: topics.length,
                    itemBuilder: (context, index) {
                      final topic = topics[index];
                      return IntrinsicHeight(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[200] ?? Colors.grey),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            children: [
                              Text(
                                topic['name'],
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 1.0,
                                ),
                              ),
                              if (topic['count'] != null) ...[
                                5.wS,
                                Text('(${topic['count'].toString()})', style: TextStyle(color: Colors.grey.shade400)),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              5.hS,
              const Divider(thickness: 0.5, color: Colors.grey),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => Container(height: 5.h, color: Colors.grey[200]),
                itemCount: 11, // Increased by 1 to include the create post section
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      context.push('/post-details', extra: index); // Navigate to post details page
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
                      color: Colors.white,
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
                                  Text(
                                    'Fahmid Al Nayem',
                                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                                  ),
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
                          SizedBox(
                            height: 200.h,
                            child: Image.asset("assets/images/stepup_image.png", fit: BoxFit.cover),
                          ),
                          15.hS,
                          Row(
                            children: [
                              Icon(Icons.favorite_border),
                              15.wS,
                              SvgPicture.asset("assets/icons/comment.svg"),
                              5.wS,
                              Text('12', style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
                              const Spacer(),
                              Icon(Icons.bookmark_outline, color: Colors.amber, size: 24),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
