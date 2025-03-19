import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/core/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupDetailsPage extends StatefulWidget {
  const GroupDetailsPage({super.key});

  @override
  State<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> topics = [
      {'name': 'All', 'count': null},
      {'name': 'Social Media', 'count': 5},
      {'name': 'StepUp', 'count': 3},
      {'name': 'Education', 'count': 4},
      {'name': 'Courses', 'count': 2},
    ];
    String selectedTopic = 'All'; // Track the selected topic
    return Scaffold(
      appBar: AppBar(title: Text('Group Details')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/logo/logoname.png', height: 200, width: double.infinity, fit: BoxFit.contain),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10.h,
                children: [
                  Text(
                    'StepUp Gropus (SG)', // Replace with dynamic member count
                    style: TextStyle(fontSize: 16.sp, color: Colors.black, fontWeight: FontWeight.w700),
                  ),

                  Padding(
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
                                  color: Colors.white,
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
                                        color: Colors.black,
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
                  Divider(thickness: 0.5, color: Colors.grey[300]),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => Container(height: 5.h, color: Colors.grey[200]),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          context.push('/post-details', extra: index); // Navigate to post details page
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.sp),
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
          ],
        ),
      ),
    );
  }
}
