import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/core/services/auth_services.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:business_application/features/community/controller/community_controller.dart';
import 'package:business_application/features/groups/controller/groups_controller.dart';
import 'package:business_application/widgets/custom_post_cart_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupDetailsPage extends GetView<GroupsController> {
  const GroupDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Ui.isDarkMode(context);

    // Check if we need to load data (if coming directly to this page)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.groupPosts.isEmpty && controller.currentGroupId.value.isNotEmpty) {
        _loadData();
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(controller.groupsDetails.value.result?.name ?? "")),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchGroupPosts(controller.currentGroupId.value),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          if (controller.groupPosts.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Text(
                  'No posts available for this group.',
                  style: TextStyle(color: Colors.grey, fontSize: 14.sp, fontWeight: FontWeight.w500),
                ),
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  controller.groupsDetails.value.result?.imageUrl ?? "",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10.h,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                                  extra: {'isGroupTopics': true, 'groupId': controller.currentGroupId.value},
                                ); // Pass argument
                              },
                              style: TextButton.styleFrom(
                                alignment: Alignment.centerLeft,
                                backgroundColor: dark ? AppColors.dark : Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                side: BorderSide(color: Colors.blue.shade100),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                              ),
                              child: Text(
                                'Creatre a Post!',
                                style: GoogleFonts.plusJakartaSans(color: Colors.grey, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          height: 25.h,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) => SizedBox(width: 5.w),
                            itemCount: controller.groupsTopicResponse.value.result?.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              final topic = controller.groupsTopicResponse.value.result?.data?[index];
                              return Obx(() {
                                final isSelected = controller.selectedTopic.value == topic?.name;
                                return GestureDetector(
                                  onTap: () {
                                    controller.selectedTopic.value = topic?.name ?? "";
                                    controller.filterPostsByTopic(topic?.name ?? "", topicId: topic?.id?.toString());
                                  },
                                  child: IntrinsicHeight(
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
                                  ),
                                );
                              });
                            },
                          ),
                        ),
                      );
                    }),
                    Divider(thickness: 0.5, color: dark ? AppColors.darkerGrey : Colors.grey[300]),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (controller.groupPosts.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Text(
                              'No posts available for this group.',
                              style: TextStyle(color: Colors.grey, fontSize: 14.sp, fontWeight: FontWeight.w500),
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (_, __) => Container(height: 2.h, color: AppColors.darkGrey),
                        itemCount: controller.groupPosts.length, // Use groupPosts here
                        itemBuilder: (context, index) {
                          final posts = controller.groupPosts[index]; // Use groupPosts here
                          return UserPostWidget(
                            onTap: () {
                              Get.find<CommunityController>().selectedPostId.value = posts.id ?? 0;
                              Get.find<CommunityController>().getCommunityPostsById(posts.id.toString());
                              Get.find<CommunityController>().getComments(posts.id.toString());

                              // CRITICAL: Make sure isGroupPost is explicitly set to true
                              debugPrint("GROUP DETAILS PAGE: Navigating to post details with isGroupPost=true");

                              context.push(
                                '/post-details/${posts.id}',
                                extra: {
                                  'isGroupPost': true, // Ensure this is set to true
                                  'groupId': controller.currentGroupId.value,
                                  'postId': posts.id.toString(),
                                },
                              );
                            },
                            name: posts.user?.name ?? "",
                            postId: posts.id,
                            rank: posts.user?.rank?.name ?? "",
                            topic: posts.topic?.name ?? "",
                            time: posts.createdAt ?? DateTime.now(),
                            postImage: posts.image ?? "",
                            videoUrl: posts.videoUrl ?? "",
                            dp: posts.user?.avatar ?? "",
                            caption: posts.content ?? "",
                            commentCount: posts.commentsCount?.toString() ?? "0",
                            isLiked: posts.isLiked ?? false,
                            isSaved: posts.isSaved ?? false,
                            onLike: () {
                              controller.selectedPostId.value = posts.id ?? 0; // Add this line
                              controller.likePosts(context);
                              controller.update(); // Ensure UI updates after liking a post
                            },
                            onSave: () {
                              controller.selectedPostId.value = posts.id ?? 0; // Add this line
                              controller.saveGroupPosts(context);
                              controller.update(); // Ensure UI updates after saving a post
                            },
                          );
                        },
                      );
                    }),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Method to reload all data if needed
  Future<void> _loadData() async {
    final groupId = controller.currentGroupId.value;
    if (groupId.isEmpty) return;

    controller.isLoading(true);
    try {
      await Future.wait([
        controller.fetchGroupsTopic(groupId),
        controller.fetchGroupsDetails(groupId),
        controller.fetchGroupPosts(groupId),
      ]);
    } catch (e) {
      debugPrint("Error loading data: $e");
    } finally {
      controller.isLoading(false);
    }
  }
}
