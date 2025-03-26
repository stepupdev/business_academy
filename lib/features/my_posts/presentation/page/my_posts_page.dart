import 'package:business_application/core/config/app_routes.dart';
import 'package:business_application/features/community/controller/community_controller.dart';
import 'package:business_application/features/my_posts/controller/my_posts_controller.dart';
import 'package:business_application/widgets/custom_post_cart_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

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
          return Center(child: Text('No posts found'));
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
