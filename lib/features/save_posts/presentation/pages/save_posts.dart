import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/features/community/controller/community_controller.dart';
import 'package:business_application/features/save_posts/controller/save_post_controller.dart';
import 'package:business_application/widgets/custom_post_cart_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SavePostsPage extends StatefulWidget {
  const SavePostsPage({super.key});

  @override
  State<SavePostsPage> createState() => _SavePostsPageState();
}

class _SavePostsPageState extends State<SavePostsPage> {
  late SavePostController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<SavePostController>();
    controller.getSavePosts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Restore scroll position when returning from post details
    controller.restoreScrollPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Posts', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 18.sp)),
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.getSavePosts(),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          if (controller.savePosts.value.result?.data?.isEmpty ?? true) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 80.sp, color: Colors.grey.shade400),
                  10.hS,
                  Text(
                    "No Saved Posts",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  5.hS,
                  Text(
                    "Save posts to view them here.",
                    style: GoogleFonts.plusJakartaSans(fontSize: 14.sp, color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            controller: controller.scrollController, // Add scroll controller here
            itemCount: controller.savePosts.value.result?.data?.length,
            itemBuilder: (context, index) {
              final post = controller.savePosts.value.result?.data?[index];
              return UserPostWidget(
                onTap: () {
                  // Save scroll position before navigating
                  controller.saveScrollPosition();

                  Get.find<CommunityController>().getCommunityPostsById(post?.id.toString() ?? "0");
                  Get.find<CommunityController>().getComments(post?.id.toString() ?? "0");
                  Get.find<CommunityController>().selectedPostId.value = post?.id ?? 0;

                  context.push('/post-details/${post?.id}');
                },
                name: post?.user?.name ?? "",
                rank: post?.user?.rank?.name ?? "",
                topic: post?.topic?.name ?? "",
                time: post?.createdAt ?? DateTime.now(),
                postImage: post?.image ?? "",
                videoUrl: post?.videoUrl ?? "",
                dp: post?.user?.avatar ?? "",
                caption: post?.content ?? "",
                commentCount: post?.commentsCount.toString() ?? "",
                isLiked: post?.isLiked ?? false,
                isSaved: post?.isSaved ?? false,
                onSave: () {
                  final communityController = Get.find<CommunityController>();
                  communityController.selectedPostId.value = post?.id ?? 0;

                  // Update UI optimistically
                  int postIndex = controller.savePosts.value.result?.data?.indexWhere((p) => p.id == post?.id) ?? -1;
                  if (postIndex != -1) {
                    bool currentState = controller.savePosts.value.result!.data![postIndex].isSaved ?? false;
                    controller.savePosts.value.result!.data![postIndex].isSaved = !currentState;
                    controller.savePosts.refresh();
                  }

                  // API call
                  communityController.savePost(context);
                },
                onLike: () {
                  final communityController = Get.find<CommunityController>();
                  communityController.selectedPostId.value = post?.id ?? 0;

                  // Update UI optimistically
                  int postIndex = controller.savePosts.value.result?.data?.indexWhere((p) => p.id == post?.id) ?? -1;
                  if (postIndex != -1) {
                    bool currentState = controller.savePosts.value.result!.data![postIndex].isLiked ?? false;
                    controller.savePosts.value.result!.data![postIndex].isLiked = !currentState;
                    controller.savePosts.refresh();
                  }

                  // Call controller method
                  communityController.likePosts(context);
                },
              );
            },
          );
        }),
      ),
    );
  }
}
