import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:business_application/features/community/controller/community_controller.dart';
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
  String? _replyingTo;

  String formatTime(DateTime time) {
    final dateTime = DateTime.now().subtract(DateTime.now().difference(time));
    return timeago.format(dateTime, locale: 'en');
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildComment(
    BuildContext context,
    String avatarText,
    String userName,
    String commentText,
    List<Widget> replies,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(child: Text(avatarText)),
          title: Text(userName, style: GoogleFonts.plusJakartaSans(fontSize: 14.sp)),
          subtitle: Text(commentText, style: GoogleFonts.plusJakartaSans(fontSize: 12.sp)),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _isReplying = true;
              _replyingTo = userName;
            });
          },
          child: Text('Reply', style: TextStyle(color: Colors.blue, fontSize: 12.sp)),
        ),
        if (replies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: replies),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Ui.isDarkMode(context);
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
        if (Get.find<CommunityController>().isLoading.value) {
          return PostDetailsShimmer();
        }
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  final controller = Get.find<CommunityController>();
                  final post = controller.communityPostsById.value.result;

                  return PostDetailsCard(
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
                  );
                }),
                Divider(height: 1.h),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Comments",
                    style: GoogleFonts.plusJakartaSans(fontSize: 15.sp, fontWeight: FontWeight.w700),
                  ),
                ),
                _buildComment(context, 'U1', 'User1', 'Nice post!', [
                  _buildComment(context, 'U3', 'User3', 'Thanks!', []),
                ]),
                _buildComment(context, 'U2', 'User2', 'Great picture!', []),
                // ...additional comments...
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 25.r, child: Text('FN')),
                      10.wS,
                      Expanded(
                        child: TextFormField(
                          onTapOutside: (event) => FocusScope.of(context).unfocus(),
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: _isReplying ? 'Replying to $_replyingTo' : 'Add comment',
                            contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                            hintStyle: TextStyle(color: Colors.grey.shade500),
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
                      SvgPicture.asset("assets/icons/share.svg", height: 24.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
