import 'package:stepup_community/core/config/app_size.dart';
import 'package:stepup_community/core/utils/helper_utils.dart';
import 'package:stepup_community/core/utils/ui_support.dart';
import 'package:stepup_community/features/community/controller/community_controller.dart';
import 'package:stepup_community/features/notification/controller/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

class NotificationPage extends GetView<NotificationController> {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.fetchNotifications();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 18.sp)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: HeroIcon(HeroIcons.cog6Tooth),
            onPressed: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(100.w, 80.h, 0, 0),
                items: [
                  PopupMenuItem(
                    value: 'mark_all_read',
                    child: Text('Mark all read'),
                    onTap: () {
                      controller.markAllReadNotification(context);
                    },
                  ),
                ],
              ).then((value) {
                if (value == 'settings') {
                  // Navigate to settings page
                } else if (value == 'logout') {
                  // Logout logic
                }
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          if (controller.notifications.value.result?.data?.isEmpty ?? true) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HeroIcon(HeroIcons.bell, size: 80.sp, color: Colors.grey.shade400),
                  10.hS,
                  Text(
                    "No Notifications Yet",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }
          return Obx(() {
            return ListView.builder(
              itemCount: controller.notifications.value.result?.data?.length,
              itemBuilder: (context, index) {
                final notification = controller.notifications.value.result?.data?[index];
                return InkWell(
                  onTap: () async {
                    // Show a loading dialog while fetching the post
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => Center(child: CircularProgressIndicator()),
                    );

                    try {
                      if (notification?.isRead == false) {
                        controller.markReadNotification(notification?.id.toString() ?? "", context);
                      }
                      controller.checkNotification();

                      final isComment = notification?.notifiableType == "App\\Models\\Comment";
                      debugPrint("Notification Type: ${notification?.notifiableType}");
                      debugPrint("Is Comment: $isComment");

                      if (isComment) {
                        final commentId = notification?.notifiableId.toString() ?? "";
                        debugPrint("Comment ID: $commentId");
                        await Get.find<CommunityController>().getCommentById(commentId).then((comment) async {
                          Navigator.of(context).pop();
                          final postId =
                              Get.find<CommunityController>().commentById.value.result?.postId.toString() ?? "";

                          await Get.find<CommunityController>().getCommunityPostsById(postId);
                          debugPrint("Post ID: $postId");
                          if (postId.isNotEmpty) {
                            GoRouter.of(context).push('/post-details/$postId', extra: {'commentId': commentId});
                          } else {
                            Ui.showErrorSnackBar(context, message: "Post not found");
                          }
                        });
                      } else {
                        // Fetch the post by ID
                        final postId = notification?.notifiableId.toString() ?? "";
                        debugPrint("Post ID: $postId");
                        debugPrint("Notification ID: ${notification?.id}");
                        debugPrint("Notifiable ID: ${notification?.notifiableId}");
                        await Get.find<CommunityController>().getCommunityPostsById(postId);

                        // Get the fetched post data
                        final post = Get.find<CommunityController>().communityPostsById.value.result;

                        // Close the loading dialog
                        Navigator.of(context).pop();

                        // Navigate to the PostDetailsPage with the post data
                        if (post != null) {
                          GoRouter.of(context).push('/post-details/$postId', extra: {'post': post});
                        } else {
                          // Show an error if the post is not found
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post not found')));
                        }
                      }
                    } catch (e) {
                      // Close the loading dialog and show an error message
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load post')));
                    }
                  },

                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        10.wS,
                        CircleAvatar(
                          radius: 25.r,
                          child: SvgPicture.asset('assets/logo/logo.svg', width: 30.0, height: 30.0),
                        ),
                        10.wS,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Visibility(
                                    visible: notification?.isRead == false,
                                    child: Container(
                                      width: 10.0,
                                      height: 10.0,
                                      decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                                      child: 10.wS,
                                    ),
                                  ),
                                  Text(
                                    HelperUtils.formatTime(notification?.createdAt ?? DateTime.now()),
                                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                "${notification?.fromUser?.name ?? ""} ${notification?.type ?? ""}",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: notification?.isRead ?? false ? FontWeight.w500 : FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Builder(
                          builder: (buttonContext) {
                            return IconButton(
                              onPressed: () async {
                                if (controller.notificationLoading[notification?.id.toString()] == true) return;

                                final RenderBox button = buttonContext.findRenderObject() as RenderBox;
                                final Offset offset = button.localToGlobal(Offset.zero);
                                final RelativeRect position = RelativeRect.fromLTRB(
                                  offset.dx,
                                  offset.dy,
                                  offset.dx + button.size.width,
                                  offset.dy + button.size.height,
                                );

                                final result = await showMenu(
                                  context: buttonContext,
                                  position: position,
                                  items: [
                                    PopupMenuItem(
                                      value: 'mark_read_unread',
                                      child: Obx(() {
                                        return controller.notificationLoading[notification?.id.toString()] == true
                                            ? SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(strokeWidth: 2),
                                            )
                                            : Text(notification?.isRead == false ? "Mark as read" : "Mark as unread");
                                      }),
                                    ),
                                  ],
                                );

                                if (result == 'mark_read_unread') {
                                  controller.markReadUnreadNotification(
                                    notification?.id.toString() ?? "",
                                    buttonContext,
                                  );
                                }
                              },
                              icon: Icon(Icons.more_vert, color: Colors.grey, size: 18.sp),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          });
        }),
      ),
    );
  }
}
