import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/core/services/auth_services.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:business_application/features/community/controller/community_controller.dart';
import 'package:business_application/features/community/presentation/widgets/comment_widget.dart';
import 'package:business_application/features/community/presentation/widgets/post_details_card.dart';
import 'package:business_application/features/community/presentation/widgets/post_details_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostDetailsPage extends StatefulWidget {
  final String postId;
  final bool isVideo;
  const PostDetailsPage({super.key, this.isVideo = true, required this.postId});

  @override
  PostDetailsPageState createState() => PostDetailsPageState();
}

class PostDetailsPageState extends State<PostDetailsPage> {
  final TextEditingController _commentController = TextEditingController();
  bool _isReplying = false;
  int? _replyingTo;

  String formatTime(DateTime time) {
    final dateTime = DateTime.now().subtract(DateTime.now().difference(time));
    return timeago.format(dateTime, locale: 'en');
  }

  @override
  void initState() {
    Get.find<CommunityController>().getComments(widget.postId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Ui.isDarkMode(context);
    final controller = Get.find<CommunityController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: dark ? AppColors.dark : AppColors.light,
        title: Text('Post Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: dark ? Colors.white : Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return PostDetailsShimmer();
        }

        final post = controller.communityPostsById.value.result;

        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PostDetailsCard(
                        onTap: () {},
                        name: post?.user?.name ?? "",
                        rank: post?.user?.rank?.name ?? "",
                        topic: post?.topic?.name ?? "",
                        postId: int.tryParse(widget.postId),
                        time: formatTime(post?.createdAt ?? DateTime.now()),
                        postImage: post?.image ?? "",
                        videoUrl: post?.videoUrl ?? "",
                        dp: post?.user?.avatar ?? "",
                        caption: post?.content ?? "",
                        commentCount: post?.commentsCount?.toString() ?? "",
                        isLiked: post?.isLiked ?? false,
                        isSaved: post?.isSaved ?? false,
                        onLike: () {
                          controller.selectedPostId.value = post?.id ?? 0;
                          controller.likePosts();
                          controller.communityPostsById.refresh(); // Trigger UI update
                        },
                        onSave: () {
                          controller.selectedPostId.value = post?.id ?? 0;
                          controller.savePost();
                          controller.communityPostsById.refresh(); // Trigger UI update
                        },
                      ),
                      Divider(height: 1.h),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Comments",
                          style: GoogleFonts.plusJakartaSans(fontSize: 15.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Obx(() {
                        final comments = controller.comments.value.result?.data ?? [];
                        if (comments.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Text(
                                'No comments available.',
                                style: TextStyle(color: Colors.grey, fontSize: 14.sp, fontWeight: FontWeight.w500),
                              ),
                            ),
                          );
                        }
                        if (controller.isLoading.value) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final comment = comments[index];
                            return CommentWidget(
                              avatarUrl: comment.user?.avatar ?? '',
                              userName: comment.user?.name ?? '',
                              content: comment.content ?? '',
                              replies: comment.replies ?? [],
                              onReply: () {
                                setState(() {
                                  _isReplying = true;
                                  _replyingTo = comment.id;
                                });
                              },
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22.r,
                      backgroundImage: NetworkImage(
                        Get.find<AuthService>().currentUser.value.result?.user?.avatar ?? '',
                      ),
                    ),
                    10.wS,
                    Expanded(
                      child: TextFormField(
                        onTapOutside: (event) => FocusScope.of(context).unfocus(),
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText:
                              _isReplying
                                  ? 'Replying to ${controller.comments.value.result?.data?.firstWhere((element) => element.id == _replyingTo).user?.name ?? ''}'
                                  : 'Add comment',
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12.sp,
                            overflow: TextOverflow.ellipsis,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(color: AppColors.borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(color: AppColors.borderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(color: AppColors.borderColor),
                          ),
                        ),
                      ),
                    ),
                    10.wS,
                    InkWell(
                      onTap: () {
                        print("here is the _replyto: $_replyingTo");
                        controller.selectedPostId.value = post?.id ?? 0;
                        controller.addComments(
                          postId: controller.selectedPostId.value.toString(),
                          comments: _commentController.text.trim(),
                          parentId: _isReplying ? _replyingTo.toString() : "",
                        );
                        _commentController.clear();
                        setState(() {
                          _isReplying = false;
                          _replyingTo = null;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Comment added successfully'), duration: Duration(seconds: 2)),
                        );
                      },
                      child: SvgPicture.asset(
                        "assets/icons/share.svg",
                        height: 24.h,
                        color: dark ? Colors.grey[300] : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
