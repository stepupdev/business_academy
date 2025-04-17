import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/features/community/controller/community_controller.dart';
import 'package:business_application/features/my_posts/controller/my_posts_controller.dart';
import 'package:business_application/widgets/custom_post_cart_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class MyPostsPage extends StatefulWidget {
  const MyPostsPage({super.key});

  @override
  State<MyPostsPage> createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage> {
  late MyPostsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<MyPostsController>();
    controller.getMyPosts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Restore scroll position when returning to this page
    controller.restoreScrollPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Posts', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 18.sp)),
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.getMyPosts(),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.myPosts.value.result?.data?.isEmpty ?? true) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.post_add, size: 80.sp, color: Colors.grey.shade400),
                  10.hS,
                  Text(
                    "No Posts Available",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  5.hS,
                  Text(
                    "Create a post to see it here.",
                    style: GoogleFonts.plusJakartaSans(fontSize: 14.sp, color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            separatorBuilder: (_, __) => Container(height: 2.h, color: AppColors.grey),
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: controller.myPosts.value.result?.data?.length ?? (controller.isPaginating.value ? 1 : 0),
            itemBuilder: (context, index) {
              final posts = controller.myPosts.value.result?.data ?? [];
              if (index == posts.length && controller.isPaginating.value) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final post = posts[index];
              return UserPostWidget(
                onTap: () {
                  controller.saveScrollPosition();

                  Get.find<CommunityController>().getCommunityPostsById(post.id.toString());
                  Get.find<CommunityController>().getComments(post.id.toString());
                  Get.find<CommunityController>().selectedPostId.value = post.id ?? 0;

                  context.push('/post-details/${post.id}', extra: {'post' : post});
                },
                name: post.user?.name ?? "",
                rank: post.user?.rank?.name ?? "",
                topic: post.topic?.name ?? "",
                time: post.createdAt ?? DateTime.now(),
                postImage: post.image ?? "",
                videoUrl: post.videoUrl ?? "",
                dp: post.user?.avatar ?? "",
                caption: post.content ?? "",
                commentCount: post.commentsCount.toString(),
                isLiked: post.isLiked ?? false,
                isSaved: post.isSaved ?? false,
                onSave: () {
                  final postId = post.id ?? 0;
                  if (postId == 0) return;

                  controller.handlePostInteraction(postId, 'save', context);
                },
                onLike: () {
                  final postId = post.id ?? 0;
                  if (postId == 0) return;

                  controller.handlePostInteraction(postId, 'like', context);
                },
              );
            },
          );
        }),
      ),
    );
  }
}
