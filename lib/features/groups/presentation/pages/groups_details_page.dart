import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/core/services/auth_services.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:business_application/features/groups/controller/groups_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupDetailsPage extends GetView<GroupsController> {
  const GroupDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Ui.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(title: Text('Group Details')),
      body: Obx(() {
        return SingleChildScrollView(
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
                      controller.groupsDetails.value.result?.name ?? "",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: dark ? AppColors.white : Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
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
                                backgroundColor: dark ? AppColors.dark : Colors.white,
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
                    Obx(() {
                      if (controller.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          height: 25.h,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) => SizedBox(width: 5.w),
                            itemCount: controller.groupsTopicResponse.value.result?.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              final topic = controller.groupsTopicResponse.value.result?.data?[index];
                              return Obx(() {
                                final isSelected = controller.selectedTopic.value == topic?.name;
                                return GestureDetector(
                                  onTap: () {
                                    controller.selectedTopic.value = topic?.name ?? "";
                                  },
                                  child: IntrinsicHeight(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                                      decoration: BoxDecoration(
                                        color: dark ? AppColors.dark : Colors.white,
                                        border: Border.all(
                                          color:
                                              isSelected ? AppColors.primaryColor : (Colors.grey[200] ?? Colors.grey),
                                          width: 0.5,
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            topic?.name ?? "",
                                            style: GoogleFonts.plusJakartaSans(
                                              color: dark ? AppColors.light : Colors.black,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              height: 1.0,
                                            ),
                                          ),
                                          if (topic?.postsCount != null && topic?.name != "All") ...[
                                            5.wS,
                                            Text(
                                              '(${topic?.postsCount.toString()})',
                                              style: TextStyle(color: Colors.grey.shade400),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                            },
                          ),
                        ),
                      );
                    }),
                    Divider(thickness: 0.5, color: dark ? AppColors.darkerGrey : Colors.grey[300]),
                    Obx(() {
                      if (controller.filteredPosts.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Text(
                              'No posts available for the selected topic.',
                              style: TextStyle(color: Colors.grey, fontSize: 14.sp, fontWeight: FontWeight.w500),
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder:
                            (context, index) =>
                                Container(height: 5.h, color: dark ? AppColors.darkerGrey : Colors.grey[300]),
                        itemCount: controller.filteredPosts.length,
                        itemBuilder: (context, index) {
                          final post = controller.filteredPosts[index];
                          return GestureDetector(
                            onTap: () {
                              context.push('/post-details', extra: post.id); // Navigate to post details page
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.sp),
                              color: dark ? AppColors.dark : Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(backgroundImage: NetworkImage(post.user?.avatar ?? "")),
                                      10.wS,
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            post.user?.name ?? "",
                                            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            post.createdAt ?? "",
                                            style: GoogleFonts.plusJakartaSans(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      10.wS,
                                      Text(
                                        post.topic?.name ?? "",
                                        style: GoogleFonts.plusJakartaSans(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  15.hS,
                                  Text(post.content ?? ""),
                                  15.hS,
                                  if (post.image != null)
                                    SizedBox(height: 200.h, child: Image.network(post.image!, fit: BoxFit.cover)),
                                  15.hS,
                                  Row(
                                    children: [
                                      Icon(Icons.favorite_border),
                                      15.wS,
                                      SvgPicture.asset("assets/icons/comment.svg"),
                                      5.wS,
                                      Text(
                                        post.commentsCount?.toString() ?? "0",
                                        style: GoogleFonts.plusJakartaSans(color: Colors.grey),
                                      ),
                                      const Spacer(),
                                      Icon(Icons.bookmark_outline, color: Colors.amber, size: 24),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
