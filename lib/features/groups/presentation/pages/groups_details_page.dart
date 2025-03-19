import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/core/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupDetailsPage extends StatelessWidget {
  const GroupDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  const Divider(),
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
          ],
        ),
      ),
    );
  }
}
