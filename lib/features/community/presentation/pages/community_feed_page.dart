// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_routes.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/core/services/auth_services.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:business_application/widgets/custom_post_cart_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:business_application/features/community/presentation/widgets/custom_shimmer.dart';

class CommunityFeedScreen extends StatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  CommunityFeedScreenState createState() => CommunityFeedScreenState();
}

class CommunityFeedScreenState extends State<CommunityFeedScreen> {
  final List<Map<String, dynamic>> topics = [
    {'name': 'All', 'count': null},
    {'name': 'Social Media', 'count': 5},
    {'name': 'StepUp', 'count': 3},
    {'name': 'Education', 'count': 4},
    {'name': 'Courses', 'count': 2},
  ];

  bool isLoading = true;
  String selectedTopic = 'All'; // Track the selected topic

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = Ui.isDarkMode(context);
    return Scaffold(
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
        titleSpacing: 10.w,
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
            backgroundColor: AppColors.primaryColor,
            child: IconButton(
              icon: Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () {
                context.push(AppRoutes.notification);
              },
            ),
          ),
          10.wS,
          CircleAvatar(
            backgroundColor: AppColors.primaryColor,
            child: IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                context.push(AppRoutes.search);
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child:
            isLoading
                ? CustomShimmer(topics: topics)
                : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        color: dark ? AppColors.dark : Color(0xffE9F0FF),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
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
                                    backgroundColor: dark ? AppColors.dark : Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                    side: BorderSide(color: Colors.blue.shade100),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                  ),
                                  child: Text(
                                    'Creatre a Post!',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: dark ? AppColors.light : Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
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
                              final isSelected = selectedTopic == topic['name'];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTopic = topic['name'];
                                  });
                                },
                                child: IntrinsicHeight(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                                    decoration: BoxDecoration(
                                      color: dark ? AppColors.dark : Colors.white,
                                      border: Border.all(
                                        color: isSelected ? AppColors.primaryColor : (Colors.grey[200] ?? Colors.grey),
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          topic['name'],
                                          style: GoogleFonts.plusJakartaSans(
                                            color: dark ? AppColors.light : Colors.black,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            height: 1.0,
                                          ),
                                        ),
                                        if (topic['count'] != null) ...[
                                          5.wS,
                                          Text(
                                            '(${topic['count'].toString()})',
                                            style: TextStyle(color: Colors.grey.shade400),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      5.hS,
                      Divider(thickness: 0.5, color: Colors.grey[200]),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder:
                            (context, index) =>
                                Container(height: 5.h, color: dark ? AppColors.darkerGrey : Colors.grey[200]),
                        itemCount: 11, // Increased by 1 to include the create post section
                        itemBuilder: (context, index) {
                          return UserPostWidget(
                            name: 'Fahmid Al Nayem',
                            rank: 'Rank $index',
                            topic: selectedTopic == "All" ? topics[index % topics.length]['name'] : selectedTopic,
                            time: '2 hours ago',
                            postImage: 'assets/images/stepup_image.png',
                            dp: Get.find<AuthService>().currentUser.value.result?.user?.avatar ?? "",
                            caption: 'This is the caption for post $index',
                            commentCount: '12',
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
