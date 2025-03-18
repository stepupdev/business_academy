import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_routes.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/features/auth/controller/auth_controller.dart';
import 'package:business_application/features/community/controller/community_controller.dart';
import 'package:business_application/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();
    final communityController = Get.put(CommunityController());
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), automaticallyImplyLeading: true, backgroundColor: Colors.white),
      body: Obx(() {
        return Container(
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
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(authService.currentUser.value.result?.user?.avatar ?? ""),
                ),
                SizedBox(height: 10),
                Text(
                  authService.currentUser.value.result?.user?.name ?? "",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10),
                Text(
                  authService.currentUser.value.result?.user?.email ?? "",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: HeroIcon(HeroIcons.userGroup),
                        title: Text('Switch Community'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (context) {
                              return Obx(() {
                                return Column(
                                  children: [
                                    Container(
                                      width: 40.w,
                                      height: 5.h,
                                      margin: EdgeInsets.symmetric(vertical: 10.h),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    Text(
                                      "Switch Community",
                                      style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700),
                                    ),
                                    20.hS,
                                    Expanded(
                                      child: ListView.builder(
                                        padding: const EdgeInsets.all(16.0),
                                        itemCount: communityController.communities.length,
                                        itemBuilder: (context, index) {
                                          final community = communityController.communities[index];
                                          final isSelected =
                                              community.id == communityController.selectedCommunityId.value;
                                          return ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                community.imageUrl.isNotEmpty
                                                    ? community.imageUrl
                                                    : 'https://s3-alpha-sig.figma.com/img/f8a3/11ee/624d5c6c6457029c05e89e81ac6882ab?Expires=1743379200&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=hScOEIqEn5wtub6NMJ849GdedyxVifSWD6fHLLn3qrc2E0eDGI7p~onPifLf0OAu29CzZTAYLhj4E8LDFs~koGpLUjNuqqsX4KJEpYFzSTL19RPR479kqW~i4SjjGuSviyb-I-6lQPC2imp7wZjtaobMqDT55ZO-eZaqb67d0qRBhR19vtIKgBRxkks3sSyNguPn3ZYCdUUa5VgUcyhGB2TDiei5~9zO211VLyEKu5uy5~~5-zpXPCdxuLUs0o8VFy65DTgbGfl1oB1r5snWHbPr~c4a32iSA9QvBWTzOf25b~jQnYrGddqxolA1z62I-3ueLavcGkacHO26W8GZjQ__',
                                              ),
                                              radius: 20,
                                            ),
                                            title: Text(
                                              community.name.isNotEmpty ? community.name : 'Unknown Community',
                                              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                                            ),
                                            subtitle: Row(
                                              children: [
                                                Text(
                                                  '${community.newPosts}+ posts',
                                                  style: GoogleFonts.plusJakartaSans(
                                                    color: AppColors.primaryColor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.symmetric(horizontal: 8),
                                                  height: 8,
                                                  width: 8,
                                                  decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                                                ),
                                                Text(
                                                  '${community.totalMembers} members',
                                                  style: GoogleFonts.plusJakartaSans(
                                                    color: Colors.grey.shade600,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            trailing:
                                                isSelected
                                                    ? Icon(Icons.check_circle, color: AppColors.primaryColor)
                                                    : null,
                                            onTap: () {
                                              communityController.changeCommunity(community.id);
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              });
                            },
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.play_circle_outline),
                        title: Text('My Courses'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Handle My Courses action
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.bookmark_outline),
                        title: Text('Saved Posts'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Handle Bookmark action
                          context.push(AppRoutes.savedPosts);
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
                        Get.find<AuthController>().signOut(context);
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
        );
      }),
    );
  }
}
