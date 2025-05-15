import 'package:stepup_community/core/config/app_colors.dart';
import 'package:stepup_community/core/config/app_size.dart';
import 'package:stepup_community/core/utils/app_strings.dart';
import 'package:stepup_community/core/utils/ui_support.dart';
import 'package:stepup_community/features/announcements/controller/announcement_controller.dart';
import 'package:stepup_community/features/community/controller/community_controller.dart';
import 'package:stepup_community/widgets/custom_post_cart_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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
      appBar: AppBar(title: const Text('Announcements'), backgroundColor: dark ? AppColors.dark : Colors.white),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchAnnouncements();
        },
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.announcements.value.result?.data?.isEmpty ?? true) {
            return Center(
              heightFactor: 3.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.announcement_outlined, size: 80.sp, color: Colors.grey.shade400),
                  10.hS,
                  Text(
                    AppStrings.noAnnouncementFound,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: controller.announcements.value.result?.data?.length ?? 0,
            separatorBuilder: (_, __) => Container(height: 2.h, color: AppColors.darkGrey),
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final announcement = controller.announcements.value.result?.data?[index];
              return UserPostWidget(
                onTap: () {
                  // First save the scroll position
                  Get.find<CommunityController>().saveScrollPosition();
                  Get.find<CommunityController>().shouldRestorePosition.value = true;

                  // Set up for the details page
                  // Get.find<CommunityController>().getCommunityPostsById(announcement?.id.toString() ?? "");
                  // Get.find<CommunityController>().getComments(announcement?.id.toString() ?? "");
                  Get.find<CommunityController>().selectedPostId.value = announcement?.id ?? 0;

                  // Navigate using go_router
                  context.push('/post-details/${announcement?.id}', extra: {'post': announcement});
                },
                name: announcement?.user?.name ?? "",
                postId: announcement?.id ?? 0,
                rank: announcement?.user?.rank?.name ?? "",
                topic: announcement?.topic?.name ?? "",
                time: announcement?.createdAt ?? DateTime.now(),
                postImage: announcement?.image ?? "",
                videoUrl: announcement?.videoUrl ?? "",
                dp: announcement?.user?.avatar ?? "",
                caption: Get.find<CommunityController>().cleanHtml(announcement?.content ?? ""),
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
