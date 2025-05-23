import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:business_application/features/community/controller/community_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserPostWidget extends StatefulWidget {
  const UserPostWidget({
    super.key,
    required this.onTap,
    this.onLike,
    this.onSave,
    required this.name,
    this.postId,
    required this.rank,
    required this.topic,
    required this.time,
    required this.postImage,
    required this.videoUrl,
    required this.dp,
    required this.caption,
    required this.commentCount,
    required this.isLiked,
    required this.isSaved,
  });

  final VoidCallback onTap;
  final VoidCallback? onLike;
  final VoidCallback? onSave;
  final String name;
  final int? postId;
  final String rank;
  final String topic;
  final DateTime time;
  final String postImage;
  final String videoUrl;
  final String dp;
  final String caption;
  final String commentCount;
  final bool isLiked;
  final bool isSaved;
  @override
  State<UserPostWidget> createState() => _UserPostWidgetState();
}

class _UserPostWidgetState extends State<UserPostWidget> {
  bool _isExpanded = false;
  bool _isOverflowing = false;
  String? videoThumbnail;
  String? dateTime;
  String formatTime(DateTime time) {
    final dateTime = DateTime.now().subtract(DateTime.now().difference(time));
    return timeago.format(dateTime, locale: 'en');
  }

  String? getVideoThumbnail(String? videoUrl) {
    if (videoUrl == null || videoUrl.isEmpty) return null;
    Uri uri = Uri.parse(videoUrl);
    String videoId = uri.queryParameters['v'] ?? uri.pathSegments.last;
    return "https://i.ytimg.com/vi/$videoId/hqdefault.jpg";
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOverflow();
    });
    videoThumbnail = getVideoThumbnail(widget.videoUrl);
    dateTime = formatTime(widget.time);
  }

  void _checkOverflow() {
    final textSpan = TextSpan(
      text: Get.find<CommunityController>().cleanHtml(widget.caption),
      style: GoogleFonts.plusJakartaSans(),
    );

    final textPainter = TextPainter(text: textSpan, maxLines: 3, textDirection: TextDirection.ltr)
      ..layout(maxWidth: MediaQuery.of(context).size.width - 20.w);

    if (mounted) {
      setState(() {
        _isOverflowing = textPainter.didExceedMaxLines;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Ui.isDarkMode(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      color: dark ? AppColors.dark : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// User Info
          InkWell(
            onTap: widget.onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(backgroundImage: NetworkImage(widget.dp)),
                    10.wS,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(widget.name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                            5.wS,
                            Container(
                              margin: EdgeInsets.only(left: 5.w),
                              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withAlpha(200),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                widget.rank,
                                style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 10.sp),
                              ),
                            ),
                            10.wS,
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2.w,
                              child: Text(
                                widget.topic,
                                style: GoogleFonts.plusJakartaSans(color: Colors.grey, fontSize: 12.sp),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Text(dateTime!, style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                15.hS,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Get.find<CommunityController>().cleanHtml(widget.caption),
                      style: GoogleFonts.plusJakartaSans(color: dark ? Colors.white : Colors.black),
                      maxLines: _isExpanded ? null : 3,
                      overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    ),
                    if (_isOverflowing)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        child: Text(
                          _isExpanded ? 'Show less' : 'Show more',
                          style: TextStyle(color: Colors.blue, fontSize: 14.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
                10.hS,

                /// Post Image/Video Thumbnail with Play Icon
                if (widget.postImage.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: CachedNetworkImage(
                      imageUrl: widget.postImage,
                      width: 1.sw,
                      height: 200.h,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                if (widget.videoUrl.isNotEmpty && widget.postImage.isEmpty)
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: CachedNetworkImage(
                          imageUrl: videoThumbnail ?? "",
                          width: 1.sw,
                          height: 200.h,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                      Positioned(
                        top: 70.h,
                        left: 150.w,
                        child: Container(
                          width: 60.w,
                          height: 60.w,
                          decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                          child: Icon(Icons.play_arrow, color: Colors.white, size: 40.w),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          15.hS,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap:
                    widget.onLike ??
                    () {
                      Get.find<CommunityController>().selectedPostId.value = widget.postId ?? 0;
                      Get.find<CommunityController>().likePosts(context);
                      Get.find<CommunityController>().communityPostsById.refresh();
                    },
                child: Container(
                  padding: EdgeInsets.only(right: 20.w, left: 20.h), // Increased hit area
                  child: Icon(
                    widget.isLiked ? Icons.favorite : Icons.favorite_border,
                    color:
                        widget.isLiked
                            ? Colors.red
                            : dark
                            ? AppColors.darkGrey
                            : AppColors.dark,
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: widget.onTap, // Navigate to post details
                child: Row(
                  children: [
                    SvgPicture.asset("assets/icons/comment.svg", color: dark ? AppColors.darkGrey : AppColors.dark),
                    10.wS,
                    Text(widget.commentCount, style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
                  ],
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap:
                    widget.onSave ??
                    () {
                      Get.find<CommunityController>().selectedPostId.value = widget.postId ?? 0;
                      Get.find<CommunityController>().savePost(context);
                      Get.find<CommunityController>().communityPostsById.refresh();
                    },
                child: Container(
                  padding: EdgeInsets.only(right: 20.w, left: 20.h), // Increased hit area
                  child: Icon(
                    widget.isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color:
                        widget.isSaved
                            ? Colors.amber
                            : dark
                            ? AppColors.darkGrey
                            : AppColors.dark,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
