import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_routes.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/core/services/auth_services.dart';
import 'package:business_application/core/utils/app_strings.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:business_application/features/community/controller/community_controller.dart';
import 'package:business_application/features/community/presentation/widgets/custom_shimmer.dart';
import 'package:business_application/features/home/controller/home_controller.dart';
import 'package:business_application/features/notification/controller/notification_controller.dart';
import 'package:business_application/widgets/custom_post_cart_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CommunityFeedScreen extends StatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  CommunityFeedScreenState createState() => CommunityFeedScreenState();
}

class CommunityFeedScreenState extends State<CommunityFeedScreen>
    with AutomaticKeepAliveClientMixin {
  late CommunityController controller;

  // The bucket to store scroll positions
  static final _bucket = PageStorageBucket();

  // This helps preserve the state when the widget might otherwise be disposed
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CommunityController>();
    controller.scrollController.addListener(() {
      if (controller.scrollController.position.pixels >=
          controller.scrollController.position.maxScrollExtent - 300) {
        controller.loadNextPage();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Add a print statement to verify this is being called
    debugPrint("didChangeDependencies called in CommunityFeedScreen");

    // Try to restore scroll position when coming back to this screen
    if (controller.shouldRestorePosition.value) {
      debugPrint(
        "Attempting to restore position to: ${controller.scrollOffset.value}",
      );
      controller.restoreScrollPosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(24.h),
          child: SizedBox(),
        ),
        titleSpacing: 10.w,
        title: Row(
          children: [
            SvgPicture.asset("assets/logo/bg_logo.svg"),
            10.wS,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'StepUp',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Community',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
        actionsPadding: EdgeInsets.only(right: 10.w),

        actions: [
          Stack(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryColor,
                child: IconButton(
                  icon: Icon(Icons.notifications_outlined, color: Colors.white),
                  onPressed: () {
                    context.push(AppRoutes.notification);
                  },
                ),
              ),
              Obx(() {
                return Visibility(
                  visible:
                      Get.find<NotificationController>()
                          .hasNewNotification
                          .value,
                  child: Positioned(
                    right: 0,
                    top: 1,
                    child: CircleAvatar(
                      radius: 7,
                      backgroundColor: AppColors.primaryColor,
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor: Colors.red,
                        child: Text(
                          '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
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
      body: PageStorage(
        bucket: _bucket,
        child: Obx(() {
          if (controller.isLoading.value) {
            return CustomShimmer();
          }
          return RefreshIndicator(
            onRefresh: () {
              Get.find<NotificationController>().hasNewNotification.value;
              return controller.getCommunityPosts();
            },
            child: CustomScrollView(
              key: PageStorageKey<String>('communityFeed'),
              controller: controller.scrollController,
              slivers: [
                SliverAppBar(
                  pinned: false,
                  floating: false,
                  expandedHeight: 55.h,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: dark ? AppColors.dark : Color(0xffE9F0FF),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.h,
                        vertical: 20.h,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              Get.find<AuthService>()
                                      .currentUser
                                      .value
                                      .result
                                      ?.user
                                      ?.avatar ??
                                  "",
                            ),
                          ),
                          10.wS,
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                context.push(
                                  '/create-post',
                                  extra: {'isGroupTopics': false},
                                ); // Pass argument
                              },
                              style: TextButton.styleFrom(
                                alignment: Alignment.centerLeft,
                                backgroundColor:
                                    dark ? AppColors.dark : Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                                side: BorderSide(
                                  color: Colors.blue.shade100,
                                  width: 0.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: Text(
                                AppStrings.createPostButton,
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
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _TopicSelectionHeader(
                    dark: dark,
                    controller: controller,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == controller.filteredPosts.length) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: index == 0 ? 0 : 10.h,
                            bottom: 10.h,
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      }
                      final posts = controller.filteredPosts[index];
                      return Column(
                        children: [
                          UserPostWidget(
                            onTap: () {
                              // First save the scroll position
                              controller.saveScrollPosition();
                              controller.shouldRestorePosition.value = true;

                              // Set up for the details page
                              Get.find<CommunityController>()
                                  .getCommunityPostsById(posts.id.toString());
                              Get.find<CommunityController>().getComments(
                                posts.id.toString(),
                              );
                              controller.selectedPostId.value = posts.id ?? 0;

                              // Navigate using go_router
                              context.push('/post-details/${posts.id}');
                            },
                            name: posts.user?.name ?? "",
                            postId: posts.id ?? 0,
                            rank: posts.user?.rank?.name ?? "",
                            topic: posts.topic?.name ?? "",
                            time: posts.createdAt ?? DateTime.now(),
                            postImage: posts.image ?? "",
                            videoUrl: posts.videoUrl ?? "",
                            dp: posts.user?.avatar ?? "",
                            caption: controller.cleanHtml(posts.content ?? ""),
                            commentCount:
                                posts.commentsCount?.toString() ?? "0",
                            isLiked: posts.isLiked ?? false,
                            isSaved: posts.isSaved ?? false,
                          ),
                          if (index != controller.filteredPosts.length - 1) ...[
                            Divider(height: 2.h, color: AppColors.darkGrey),
                          ],
                        ],
                      );
                    },
                    childCount:
                        controller.filteredPosts.length +
                        (controller.isPaginating.value ? 1 : 0),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _TopicSelectionHeader extends SliverPersistentHeaderDelegate {
  final bool dark;
  final CommunityController controller;

  _TopicSelectionHeader({required this.dark, required this.controller});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: 40.h,
      color: dark ? AppColors.dark : Color(0xffE9F0FF),
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Obx(() {
        if (controller.topics.value.result?.data == null) {
          return Center(
            child: Text(
              "No topics available",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }
        return SizedBox(
          height: 45.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            separatorBuilder: (context, index) => SizedBox(width: 5.w),
            scrollDirection: Axis.horizontal,
            itemCount: controller.topics.value.result?.data?.length ?? 0,
            itemBuilder: (context, index) {
              final topic = controller.topics.value.result?.data?[index];
              return Obx(() {
                final isSelected =
                    controller.selectedTopic.value == topic?.name;
                return GestureDetector(
                  onTap: () {
                    if (topic?.name == "Announcement") {
                      // navigate to the announcement page {bottom navigation page index 2}
                      Get.find<HomeController>().changeTabIndex(2, context);
                      context.go(AppRoutes.announcementsTab);
                    }
                    controller.selectedTopic.value = topic?.name ?? "";
                    controller.selectedTopicId.value =
                        topic?.id?.toString() ?? "";
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: dark ? AppColors.dark : Colors.white,
                      border: Border.all(
                        color:
                            isSelected
                                ? AppColors.primaryColor
                                : (Colors.grey[200] ?? Colors.grey),
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
                        if (topic?.postsCount != null &&
                            topic?.name != "All") ...[
                          5.wS,
                          Text(
                            '(${topic?.postsCount.toString()})',
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              });
            },
          ),
        );
      }),
    );
  }

  @override
  double get maxExtent => 40.h;

  @override
  double get minExtent => 40.h;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
