import 'package:stepup_community/core/config/app_colors.dart';
import 'package:stepup_community/core/config/app_size.dart';
import 'package:stepup_community/core/utils/app_strings.dart';
import 'package:stepup_community/features/community/controller/community_controller.dart';
import 'package:stepup_community/features/save_posts/controller/save_post_controller.dart';
import 'package:stepup_community/widgets/custom_post_cart_widgets.dart';
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

class _SavePostsPageState extends State<SavePostsPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Keep the state of this page alive

  static final _bucket = PageStorageBucket();
  late SavePostController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<SavePostController>();
    controller.getSavePosts();
    controller.scrollController.addListener(() {
      if (controller.scrollController.position.pixels >= controller.scrollController.position.maxScrollExtent - 300) {
        controller.loadNextPage();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Restore scroll position when returning from post details
    controller.restoreScrollPosition();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Call super.build to ensure the state is kept alive
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Posts', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 18.sp)),
      ),
      body: PageStorage(
        bucket: _bucket,
        child: RefreshIndicator(
          onRefresh: () => controller.getSavePosts(),
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            if (controller.savePosts.value.result?.data?.isEmpty ?? true) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bookmark_border, size: 80.sp, color: Colors.grey.shade400),
                      10.hS,
                      Text(
                        AppStrings.noSavedPostsFound,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      5.hS,
                      Text(
                        textAlign: TextAlign.center,
                        AppStrings.noSavedPostsDescription,
                        style: GoogleFonts.plusJakartaSans(fontSize: 14.sp, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.separated(
              separatorBuilder: (_, __) => Container(height: 2.h, color: AppColors.grey),
              controller: controller.scrollController, // Add scroll controller here
              itemCount: controller.savePosts.value.result?.data?.length ?? (controller.isPaginating.value ? 1 : 0),
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final posts = controller.savePosts.value.result?.data ?? [];
                if (index == posts.length && controller.isPaginating.value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final post = posts[index].post;
                return UserPostWidget(
                  onTap: () {
                    controller.saveScrollPosition();

                    Get.find<CommunityController>().getCommunityPostsById(post?.id.toString() ?? "0");
                    Get.find<CommunityController>().getComments(post?.id.toString() ?? "0");
                    Get.find<CommunityController>().selectedPostId.value = post?.id ?? 0;

                    context.push('/post-details/${post?.id}', extra: {'post': post});
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
                    final postId = post?.id ?? 0;
                    if (postId == 0) return;

                    controller.handlePostInteraction(postId, 'save', context);
                  },
                  onLike: () {
                    debugPrint("post id is ${post?.id}");

                    final postId = post?.id ?? 0;
                    if (postId == 0) return;

                    controller.handlePostInteraction(postId, 'like', context);
                  },
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
