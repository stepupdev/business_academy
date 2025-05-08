import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_routes.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/core/services/auth_services.dart';
import 'package:business_application/core/utils/app_strings.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:business_application/features/community/controller/community_controller.dart';
import 'package:business_application/features/community/presentation/widgets/custom_shimmer.dart';
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
  bool showTopButton = false;
  // This helps preserve the state when the widget might otherwise be disposed
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CommunityController>();
    controller.feedScrollController = ScrollController();
    controller.feedScrollController.addListener(() {
      if (controller.feedScrollController.hasClients) {
        controller.scrollOffset.value = controller.feedScrollController.position.pixels;
        if (controller.feedScrollController.position.pixels >=
            controller.feedScrollController.position.maxScrollExtent - 300) {
          controller.loadNextPage();
        }
      }

      if (controller.feedScrollController.offset >= 300) {
        if (mounted) {
          setState(() {
            showTopButton = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            showTopButton = false;
          });
        }
      }
    });
  }

  void scrollToTop() {
    if (controller.feedScrollController.hasClients) {
      controller.feedScrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Add a print statement to verify this is being called
    debugPrint("didChangeDependencies called in CommunityFeedScreen");

    // Try to restore scroll position when coming back to this screen
    if (controller.shouldRestorePosition.value) {
      debugPrint("Attempting to restore position to: ${controller.scrollOffset.value}");
      controller.restoreScrollPosition(controller.feedScrollController);
    }
  }

  @override
  void dispose() {
    controller.feedScrollController.dispose();
    super.dispose();
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
        bottom: PreferredSize(preferredSize: Size.fromHeight(24.h), child: SizedBox()),
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
                  style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Community',
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700),
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
                  visible: Get.find<NotificationController>().hasNewNotification.value,
                  child: Positioned(
                    right: 0,
                    top: 1,
                    child: CircleAvatar(
                      radius: 7,
                      backgroundColor: AppColors.primaryColor,
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor: Colors.red,
                        child: Text('', style: TextStyle(color: Colors.white, fontSize: 10.sp)),
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
            key: controller.refreshKey,
            onRefresh: () async {
              Get.find<NotificationController>().hasNewNotification.value;
              controller.getTopic();
              // return controller.getCommunityPosts();
              if (controller.selectedTopic.value.isNotEmpty &&
                  controller.selectedTopicId.value.isNotEmpty &&
                  controller.selectedTopic.value != "All") {
                return controller.filterPostsByTopic(
                  controller.selectedTopic.value,
                  topicId: controller.selectedTopicId.value,
                );
              } else if (controller.selectedTopic.value.isEmpty &&
                  controller.selectedTopic.value == "All") {
                controller.getTopic();
              } else {
                return controller.getCommunityPosts();
              }
            },
            child: CustomScrollView(
              key: PageStorageKey<String>('communityFeed'),
              controller: controller.feedScrollController, // Use the dedicated ScrollController
              slivers: [
                SliverAppBar(
                  pinned: false,
                  floating: false,
                  expandedHeight: 55.h,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: dark ? AppColors.dark : Color(0xffE9F0FF),
                      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 10.h),
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
                                context.push(
                                  '/create-post',
                                  extra: {'isGroupTopics': false},
                                ); // Pass argument
                              },
                              style: TextButton.styleFrom(
                                alignment: Alignment.centerLeft,
                                backgroundColor: dark ? AppColors.dark : Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                side: BorderSide(color: Colors.blue.shade100, width: 0.5),
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
                  delegate: _TopicSelectionHeader(dark: dark, controller: controller),
                ),
                if (controller.isLoading.value)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
                if (controller.filteredPosts.isEmpty ||
                    controller.communityPosts.value.result?.data == null ||
                    controller.communityPosts.value.result!.data!.isEmpty)
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height:
                          MediaQuery.of(context).size.height *
                          0.8, // enough height to make it scrollable
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.post_add, size: 80.sp, color: Colors.grey.shade400),
                          10.hS,
                          Text(
                            AppStrings.noPostsFound,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == controller.filteredPosts.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: index == 0 ? 0 : 10.h, bottom: 10.h),
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
                                // Get.find<CommunityController>().getCommunityPostsById(posts.id.toString());
                                // Get.find<CommunityController>().getComments(posts.id.toString());
                                controller.selectedPostId.value = posts.id ?? 0;

                                // Navigate using go_router
                                context.push('/post-details/${posts.id}', extra: {'post': posts});
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
                              commentCount: posts.commentsCount?.toString() ?? "0",
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
                          controller.filteredPosts.length + (controller.isPaginating.value ? 1 : 0),
                    ),
                  ),
                  if (controller.isPaginating.value)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ),
                ],
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

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 40.h,
      color: dark ? AppColors.dark : Color(0xffE9F0FF),
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Obx(() {
        if (controller.topics.value.result?.data == null) {
          return Center(child: Text("No topics available", style: TextStyle(color: Colors.grey)));
        }

        // Ensure the selected topic is centered
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final selectedIndex =
              controller.topics.value.result?.data?.indexWhere(
                (t) => t.name == controller.selectedTopic.value,
              ) ??
              -1;

          if (selectedIndex != -1) {
            final itemWidth = 100.w; // Approximate width of each item
            final screenWidth = MediaQuery.of(context).size.width;
            final offset = (selectedIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

            scrollController.animateTo(
              offset.clamp(0.0, scrollController.position.maxScrollExtent),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });

        return SizedBox(
          height: 45.h,
          child: ListView.separated(
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            separatorBuilder: (context, index) => SizedBox(width: 5.w),
            scrollDirection: Axis.horizontal,
            itemCount: controller.topics.value.result?.data?.length ?? 0,
            itemBuilder: (context, index) {
              final topic = controller.topics.value.result?.data?[index];
              return Obx(() {
                final isSelected = controller.selectedTopic.value == topic?.name;

                return GestureDetector(
                  onTap: () {
                    final topicName = topic?.name ?? "";
                    final topicId = topic?.id?.toString() ?? "";
                    controller.selectedTopic.value = topic?.name ?? "";
                    controller.selectedTopicId.value = topic?.id?.toString() ?? "";
                    if (controller.selectedTopic.value == topicName) {
                      controller.filterPostsByTopic(topicName, topicId: topicId);
                    } else {
                      controller.selectedTopic.value = topicName;
                      controller.selectedTopicId.value = topicId;
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: dark ? AppColors.dark : Colors.white,
                      border: Border.all(
                        color:
                            isSelected ? AppColors.primaryColor : (Colors.grey[200] ?? Colors.grey),
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
                        if (topic?.postsCount != null && topic?.name != "All") ...[
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
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
