// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_routes.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/core/services/auth_services.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:business_application/features/community/controller/community_controller.dart';
import 'package:business_application/widgets/custom_post_cart_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:business_application/features/community/presentation/widgets/custom_shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommunityFeedScreen extends GetView<CommunityController> {
  const CommunityFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String formatTime(DateTime time) {
      final dateTime = DateTime.now().subtract(DateTime.now().difference(time));
      return timeago.format(dateTime, locale: 'en');
    }

    final dark = Ui.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor, Color(0xFF003BC6)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        bottom: PreferredSize(preferredSize: Size.fromHeight(24.h), child: SizedBox()),
        titleSpacing: 10.w,
        title: Row(
          children: [
            SvgPicture.asset("assets/logo/bg_logo.svg"),
            10.wS,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('StepUp', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                Text('Community', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
        actionsPadding: EdgeInsets.only(right: 10.w),

        actions: [
          CircleAvatar(
            backgroundColor: AppColors.primaryColor,
            child: IconButton(
              icon: Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () {
                context.push(AppRoutes.notification);
              },
            ),
          ),
          10.wS,
          CircleAvatar(
            backgroundColor: AppColors.primaryColor,
            child: IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                context.push(AppRoutes.search);
              },
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return CustomShimmer();
        }
        return RefreshIndicator(
          onRefresh: () {
            return controller.getCommunityPosts();
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: dark ? AppColors.dark : Color(0xffE9F0FF),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 8.h),
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
                                side: BorderSide(color: Colors.blue.shade100, width: 0.5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                              ),
                              child: Text(
                                'Creatre a Post!',
                                style: GoogleFonts.plusJakartaSans(
                                  color: dark ? AppColors.light : Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Divider(color: AppColors.darkerGrey, thickness: 0.3),
                  12.hS,
                  Obx(() {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        height: 25.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) => SizedBox(width: 5.w),
                          itemCount: controller.topics.value.result?.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            final topic = controller.topics.value.result?.data?[index];
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
                                        color: isSelected ? AppColors.primaryColor : (Colors.grey[200] ?? Colors.grey),
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
                                        if (topic?.postsCount != null) ...[
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
                  5.hS,
                  Divider(color: AppColors.darkerGrey, thickness: 0.3),
                  Obx(() {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder:
                          (context, index) => Container(height: 3.h, color: dark ? Colors.black : Colors.grey[200]),
                      itemCount: controller.communityPosts.value.result?.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        String? getVideoThumbnail(String? videoUrl) {
                          if (videoUrl == null || videoUrl.isEmpty) return null;
                          Uri uri = Uri.parse(videoUrl);
                          String videoId = uri.queryParameters['v'] ?? uri.pathSegments.last;
                          return "https://i.ytimg.com/vi/$videoId/hqdefault.jpg";
                        }

                        final posts = controller.communityPosts.value.result?.data?[index];
                        final String? imageUrl = posts?.image;
                        final String? videoUrl = posts?.videoUrl;
                        final String? videoThumbnail = getVideoThumbnail(videoUrl);
                        final String? postImage =
                            imageUrl ?? videoThumbnail; // Use image if available, otherwise use video thumbnail
                        final bool isVideo = imageUrl == null && videoUrl != null;
                        var time = formatTime(posts?.createdAt ?? DateTime.now());

                        return UserPostWidget(
                          onTap: () {
                            Get.find<CommunityController>().getCommunityPostsById(posts?.id.toString() ?? "0");
                            controller.selectedPostId.value = posts?.id ?? 0;
                            context.push('/post-details:${posts?.id}');
                          },
                          name: posts?.user?.name ?? "",
                          postId: posts?.id ?? 0,
                          rank: posts?.user?.rank?.name ?? "",
                          topic: posts?.topic?.name ?? "",
                          time: time,
                          postImage: postImage ?? "", // Ensure it's never null to prevent errors
                          dp: posts?.user?.avatar ?? "",
                          caption: posts?.content ?? "",
                          commentCount: posts?.commentsCount?.toString() ?? "0",
                          isVideo: isVideo,
                          isLiked: posts?.isLiked ?? false,
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
