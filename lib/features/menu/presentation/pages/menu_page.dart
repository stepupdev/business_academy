import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_routes.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:business_application/features/auth/controller/auth_controller.dart';
import 'package:business_application/features/community/controller/community_controller.dart';
import 'package:business_application/features/menu/controller/menu_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

class MenuPage extends GetView<UserMenuController> {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CommunityController());
    final dark = Ui.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: true,
        backgroundColor: dark ? AppColors.dark : Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: dark ? [AppColors.dark, AppColors.darkerGrey] : [Color(0xFFFFFFFF), Color(0xffffdef3ff)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(radius: 50, backgroundImage: NetworkImage(controller.user.value.result?.avatar ?? "")),
                SizedBox(height: 10),
                Text(
                  controller.user.value.result?.name ?? "",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10),
                Text(
                  controller.user.value.result?.email ?? "",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: dark ? AppColors.dark : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: controller.user.value.result?.communityIds?.isNotEmpty ?? false,
                        child: ListTile(
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
                                  if (controller.isLoading.value) {
                                    return Center(child: CircularProgressIndicator());
                                  }
                                  return Column(
                                    children: [
                                      Text(
                                        "Switch Community",
                                        style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700),
                                      ),
                                      20.hS,
                                      Expanded(
                                        child: ListView.builder(
                                          padding: const EdgeInsets.all(16.0),
                                          itemCount: controller.communities.value.result?.data?.length,
                                          itemBuilder: (context, index) {
                                            final community = controller.communities.value.result?.data?[index];
                                            final isSelected =
                                                controller.user.value.result?.community?.id == community?.id;
                                            return ListTile(
                                              leading: CircleAvatar(
                                                backgroundImage: AssetImage('assets/images/stepup_image.png'),
                                                radius: 20,
                                              ),
                                              title: Text(
                                                (community?.name != null && community!.name!.isNotEmpty)
                                                    ? community.name!
                                                    : 'Unknown Community',
                                                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                                              ),
                                              // subtitle: Row(
                                              //   children: [
                                              //     Text(
                                              //       '${community.newPosts}+ posts',
                                              //       style: GoogleFonts.plusJakartaSans(
                                              //         color: AppColors.primaryColor,
                                              //         fontWeight: FontWeight.w600,
                                              //       ),
                                              //     ),
                                              //     Container(
                                              //       margin: const EdgeInsets.symmetric(horizontal: 8),
                                              //       height: 8,
                                              //       width: 8,
                                              //       decoration: BoxDecoration(
                                              //         color: Colors.grey,
                                              //         shape: BoxShape.circle,
                                              //       ),
                                              //     ),
                                              //     Text(
                                              //       '${community.totalMembers} members',
                                              //       style: GoogleFonts.plusJakartaSans(
                                              //         color: Colors.grey.shade600,
                                              //         fontWeight: FontWeight.w600,
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                              trailing:
                                                  isSelected
                                                      ? Icon(Icons.check_circle, color: AppColors.primaryColor)
                                                      : null,
                                              onTap: () async {
                                                debugPrint("Selected Community: ${community?.name}");
                                                await Get.find<CommunityController>().getCommunityPosts();
                                                final communityId = community?.id?.toString() ?? "";
                                                debugPrint("Community ID: $communityId");
                                                await controller.changeCommunity(communityId, context).then((e) {
                                                  final communityController = Get.find<CommunityController>();
                                                  communityController.getCommunityPosts();
                                                  communityController.getTopic();
                                                  controller.getUser();
                                                  controller.communities.refresh();
                                                  controller.user.refresh();
                                                });
                                                GoRouter.of(context).pop();
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
                      ),
                      ListTile(
                        leading: HeroIcon(HeroIcons.pencilSquare),
                        title: Text('My posts'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          context.push(AppRoutes.myPosts);
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
                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Get.find<AuthController>().signOut(context);
                      },
                      icon: Icon(Icons.logout, color: dark ? AppColors.light : Colors.black, size: 20),
                      label: Text(
                        'Logout',
                        style: GoogleFonts.plusJakartaSans(
                          color: dark ? AppColors.light : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
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
