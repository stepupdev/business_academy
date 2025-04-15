import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:business_application/features/announcements/controller/announcement_controller.dart';
import 'package:business_application/features/community/controller/community_controller.dart';
import 'package:business_application/widgets/custom_post_cart_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  @override
  void initState() {
    super.initState();
    Get.find<AnnouncementController>().fetchAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Ui.isDarkMode(context);
    final controller = Get.find<AnnouncementController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Announcements')),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchAnnouncements();
        },
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.announcements.value.result?.data?.isEmpty ?? true) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.construction,
                  size: 100.sp,
                  color: dark ? Colors.orangeAccent : Colors.blueAccent,
                ),
                SizedBox(height: 20.h),
                Text(
                  textAlign: TextAlign.center,
                  "Announcements Coming Soon",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Stay tuned! The announcements feature will be published soon.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: dark ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
                SizedBox(height: 30.h),
              ],
            );
          }

          return ListView.separated(
            itemCount: controller.announcements.value.result?.data?.length ?? 0,
            separatorBuilder:
                (_, __) => Container(height: 2.h, color: AppColors.darkGrey),
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final announcement =
                  controller.announcements.value.result?.data?[index];
              return UserPostWidget(
                onTap: () {
                  // First save the scroll position
                  Get.find<CommunityController>().saveScrollPosition();
                  Get.find<CommunityController>().shouldRestorePosition.value =
                      true;

                  // Set up for the details page
                  Get.find<CommunityController>().getCommunityPostsById(
                    announcement?.id.toString() ?? "",
                  );
                  Get.find<CommunityController>().getComments(
                    announcement?.id.toString() ?? "",
                  );
                  Get.find<CommunityController>().selectedPostId.value =
                      announcement?.id ?? 0;

                  // Navigate using go_router
                  context.push('/post-details/${announcement?.id}');
                },
                name: announcement?.user?.name ?? "",
                postId: announcement?.id ?? 0,
                rank: announcement?.user?.rank?.name ?? "",
                topic: announcement?.topic?.name ?? "",
                time: announcement?.createdAt ?? DateTime.now(),
                postImage: announcement?.image ?? "",
                videoUrl: announcement?.videoUrl ?? "",
                dp: announcement?.user?.avatar ?? "",
                caption: Get.find<CommunityController>().cleanHtml(
                  announcement?.content ?? "",
                ),
                commentCount: announcement?.commentsCount?.toString() ?? "0",
                isLiked: announcement?.isLiked ?? false,
                isSaved: announcement?.isSaved ?? false,
                onLike: () {
                  controller.selectedPostId.value = announcement?.id ?? 0;
                  controller.likePosts(context);
                  controller.update();
                },
                onSave: () {
                  controller.selectedPostId.value = announcement?.id ?? 0;
                  controller.saveGroupPosts(context);
                  controller.update();
                },
              );
            },
          );
        }),
      ),
    );
  }
}
