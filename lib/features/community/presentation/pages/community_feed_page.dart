import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stepup_community/core/config/app_colors.dart';
import 'package:stepup_community/core/config/app_routes.dart';
import 'package:stepup_community/core/config/app_size.dart';
import 'package:stepup_community/core/services/auth_services.dart';
import 'package:stepup_community/core/utils/ui_support.dart';
import 'package:stepup_community/features/community/controller/community_controller.dart';
import 'package:stepup_community/features/community/presentation/widgets/custom_shimmer.dart';
import 'package:stepup_community/features/notification/controller/notification_controller.dart';
import 'package:stepup_community/widgets/custom_post_cart_widgets.dart';

class CommunityFeedScreen extends StatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  CommunityFeedScreenState createState() => CommunityFeedScreenState();
}

class CommunityFeedScreenState extends State<CommunityFeedScreen> with AutomaticKeepAliveClientMixin {
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
      backgroundColor: dark ? const Color(0xFF0A0A0A) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 70.h,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor.withOpacity(0.9), const Color(0xFF003BC6).withOpacity(0.9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(color: AppColors.primaryColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 5)),
            ],
          ),
        ),
        titleSpacing: 20.w,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: SvgPicture.asset("assets/logo/bg_logo.svg", width: 24.w, height: 24.w),
            ),
            12.wS,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'StepUp',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Community',
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          _buildActionButton(
            icon: Icons.notifications_outlined,
            onTap: () => context.push(AppRoutes.notification),
            showBadge: Get.find<NotificationController>().hasNewNotification.value,
          ),
          12.wS,
          _buildActionButton(icon: Icons.search_rounded, onTap: () => context.push(AppRoutes.search)),
          20.wS,
        ],
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: showTopButton ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: FloatingActionButton(
          mini: true,
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          onPressed: scrollToTop,
          child: const Icon(Icons.keyboard_arrow_up),
        ),
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
              await controller.getTopic();
              Get.find<NotificationController>().hasNewNotification.value;
              if (controller.selectedTopic.value.isNotEmpty &&
                  controller.selectedTopicId.value.isNotEmpty &&
                  controller.selectedTopic.value != "All") {
                return controller.filterPostsByTopic(
                  controller.selectedTopic.value,
                  topicId: controller.selectedTopicId.value,
                );
              } else if (controller.selectedTopic.value.isEmpty && controller.selectedTopic.value == "All") {
                controller.getTopic();
              } else {
                return controller.getCommunityPosts();
              }
            },
            child: CustomScrollView(
              key: PageStorageKey<String>('communityFeed'),
              controller: controller.feedScrollController,
              slivers: [
                // Create Post Section
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 4.h),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: dark ? const Color(0xFF1A1A1A) : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: dark ? Colors.black12 : Colors.grey.withOpacity(0.06),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primaryColor.withOpacity(0.3), width: 1.5),
                          ),
                          child: CircleAvatar(
                            radius: 18.r,
                            backgroundImage: NetworkImage(
                              Get.find<AuthService>().currentUser.value.result?.user?.avatar ?? "",
                            ),
                          ),
                        ),
                        12.wS,
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              context.push('/create-post', extra: {'isGroupTopics': false});
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: dark ? const Color(0xFF2A2A2A) : const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: dark ? Colors.grey.shade700 : Colors.grey.shade200,
                                  width: 0.8,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "What's on your mind?",
                                      style: GoogleFonts.inter(
                                        color: dark ? Colors.grey.shade400 : Colors.grey.shade600,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Icon(Icons.image_outlined, color: AppColors.primaryColor, size: 20.sp),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Topics Section
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _ModernTopicSelectionHeader(dark: dark, controller: controller),
                ),

                // Loading indicator
                if (controller.isLoading.value)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Center(child: CircularProgressIndicator(color: AppColors.primaryColor, strokeWidth: 3)),
                    ),
                  ),

                // Empty state
                if (controller.filteredPosts.isEmpty ||
                    controller.communityPosts.value.result?.data == null ||
                    controller.communityPosts.value.result!.data!.isEmpty)
                  SliverToBoxAdapter(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.article_outlined, size: 48.sp, color: AppColors.primaryColor),
                          ),
                          20.hS,
                          Text(
                            'No Posts Yet',
                            style: GoogleFonts.poppins(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: dark ? Colors.white : Colors.grey.shade800,
                            ),
                          ),
                          8.hS,
                          Text(
                            'Be the first to share something with the community!',
                            style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey.shade500),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  // Posts list
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (index == controller.filteredPosts.length) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: Center(
                            child: CircularProgressIndicator(color: AppColors.primaryColor, strokeWidth: 3),
                          ),
                        );
                      }
                      final posts = controller.filteredPosts[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 4.h),
                        decoration: BoxDecoration(
                          color: dark ? const Color(0xFF1A1A1A) : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: dark ? Colors.black12 : Colors.grey.withOpacity(0.06),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: UserPostWidget(
                          onTap: () {
                            // First save the scroll position
                            controller.saveScrollPosition();
                            controller.shouldRestorePosition.value = true;

                            // Set up for the details page
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
                          likesCount: posts.likesCount?.toString() ?? "0",
                          commentCount: posts.commentsCount?.toString() ?? "0",
                          isLiked: posts.isLiked ?? false,
                          isSaved: posts.isSaved ?? false,
                        ),
                      );
                    }, childCount: controller.filteredPosts.length + (controller.isPaginating.value ? 1 : 0)),
                  ),
                ],

                // Bottom spacing
                SliverToBoxAdapter(child: SizedBox(height: 15.h)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required VoidCallback onTap, bool showBadge = false}) {
    return Stack(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white, size: 20.sp),
            onPressed: onTap,
            padding: EdgeInsets.zero,
          ),
        ),
        if (showBadge)
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }
}

class _ModernTopicSelectionHeader extends SliverPersistentHeaderDelegate {
  final bool dark;
  final CommunityController controller;

  _ModernTopicSelectionHeader({required this.dark, required this.controller});

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF0A0A0A) : const Color(0xFFF5F7FA),
        border: Border(bottom: BorderSide(color: dark ? Colors.grey.shade800 : Colors.grey.shade200, width: 0.5)),
      ),
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Obx(() {
        if (controller.topics.value.result?.data == null) {
          return Center(child: Text("No topics available", style: GoogleFonts.inter(color: Colors.grey.shade500)));
        }

        return SizedBox(
          height: 26.h,
          child: ListView.separated(
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            separatorBuilder: (context, index) => SizedBox(width: 6.w),
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
                    controller.selectedTopic.value = topicName;
                    controller.selectedTopicId.value = topicId;
                    controller.filterPostsByTopic(topicName, topicId: topicId);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      gradient:
                          isSelected
                              ? LinearGradient(
                                colors: [AppColors.primaryColor, const Color(0xFF003BC6)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              )
                              : null,
                      color:
                          isSelected
                              ? null
                              : dark
                              ? const Color(0xFF1A1A1A)
                              : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color:
                            isSelected
                                ? Colors.transparent
                                : dark
                                ? Colors.grey.shade700
                                : Colors.grey.shade300,
                        width: 0.8,
                      ),
                      boxShadow:
                          isSelected
                              ? [
                                BoxShadow(
                                  color: AppColors.primaryColor.withOpacity(0.25),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                              : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          topic?.name ?? "",
                          style: GoogleFonts.inter(
                            color:
                                isSelected
                                    ? Colors.white
                                    : dark
                                    ? Colors.white
                                    : Colors.grey.shade700,
                            fontSize: 11.sp,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                        if (topic?.postsCount != null && topic?.name != "All") ...[
                          3.wS,
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? Colors.white.withOpacity(0.2) : AppColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              '${topic?.postsCount}',
                              style: GoogleFonts.inter(
                                color: isSelected ? Colors.white : AppColors.primaryColor,
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
  double get maxExtent => 34.h;

  @override
  double get minExtent => 34.h;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
