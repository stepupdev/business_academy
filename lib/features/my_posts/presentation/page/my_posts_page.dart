import 'package:business_application/core/config/app_routes.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/features/community/controller/community_controller.dart';
import 'package:business_application/features/my_posts/controller/my_posts_controller.dart';
import 'package:business_application/widgets/custom_post_cart_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyPostsPage extends GetView<MyPostsController> {
  const MyPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Posts')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.myPosts.value.result?.data?.isEmpty ?? true) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.post_add, size: 80.sp, color: Colors.grey.shade400),
                10.hS,
                Text(
                  "No Posts Yet",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
                5.hS,
                Text(
                  "Create your first post to see it here.",
                  style: GoogleFonts.plusJakartaSans(fontSize: 14.sp, color: Colors.grey.shade500),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.myPosts.value.result?.data?.length,
          itemBuilder: (context, index) {
            final post = controller.myPosts.value.result?.data?[index];
            return UserPostWidget(
              onTap: () {
                Get.find<CommunityController>().getCommunityPostsById(post?.id.toString() ?? "0");
                context.push(AppRoutes.postDetails, extra: {'postId': post?.id});
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
            );
          },
        );
      }),
    );
  }
}
