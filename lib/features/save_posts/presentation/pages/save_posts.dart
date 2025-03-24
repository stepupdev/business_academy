import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_routes.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:business_application/features/community/controller/community_controller.dart';
import 'package:business_application/features/save_posts/controller/save_post_controller.dart';
import 'package:business_application/widgets/custom_post_cart_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SavePostsPage extends GetView<SavePostController> {
  const SavePostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Posts', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 18.sp)),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.savePosts.value.result?.data?.isEmpty ?? true) {
          return Center(child: Text('No posts found'));
        }
        return ListView.builder(
          itemCount: controller.savePosts.value.result?.data?.length,
          itemBuilder: (context, index) {
            final post = controller.savePosts.value.result?.data?[index];
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
