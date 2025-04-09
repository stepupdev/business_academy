import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:business_application/features/community/controller/community_controller.dart';
import 'package:business_application/features/video_player/presentation/page/yt_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PostDetailsCard extends StatefulWidget {
  const PostDetailsCard({
    super.key,
    required this.onTap,
    required this.name,
    this.postId,
    required this.rank,
    required this.topic,
    required this.time,
    this.postImage,
    this.videoUrl,
    required this.dp,
    required this.caption,
    required this.commentCount,
    required this.isLiked,
    required this.isSaved,
    this.onLike,
    this.onSave,
  });

  final VoidCallback onTap;
  final VoidCallback? onLike;
  final VoidCallback? onSave;
  final String name;
  final int? postId;
  final String rank;
  final String topic;
  final String time;
  final String? postImage;
  final String? videoUrl;
  final String dp;
  final String caption;
  final String commentCount;
  final bool isLiked;
  final bool isSaved;
  @override
  State<PostDetailsCard> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetailsCard> {
  bool _isExpanded = false;
  bool _isOverflowing = false;
  String? videoThumbnail;
  bool _isPlaying = false;

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
  }

  void _checkOverflow() {
    final textSpan = TextSpan(
      text: Get.find<CommunityController>().cleanHtml(widget.caption),
      style: GoogleFonts.plusJakartaSans(),
    );
    final textPainter = TextPainter(text: textSpan, maxLines: 3, textDirection: TextDirection.ltr)
      ..layout(maxWidth: MediaQuery.of(context).size.width - 20.w);

    setState(() {
      _isOverflowing = textPainter.didExceedMaxLines;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Ui.isDarkMode(context);
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
        color: dark ? AppColors.dark : Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// User Info
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
                      ],
                    ),
                    Text(widget.time, style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
                  ],
                ),
                10.wS,
                Expanded(
                  child: Text(
                    widget.topic,
                    style: GoogleFonts.plusJakartaSans(color: Colors.grey, fontSize: 12.sp),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            /// Caption
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
            if (widget.postImage!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.network(widget.postImage!, width: 1.sw, height: 200.h, fit: BoxFit.cover),
              ),
            if (widget.videoUrl!.isNotEmpty &&
                widget.postImage!.isEmpty &&
                !_isPlaying) // Show play icon overlay if it's a video
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => YouTubeVideoPlayer(videoUrl: widget.videoUrl!)),
                  );
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.network(videoThumbnail!, width: 1.sw, height: 200.h, fit: BoxFit.cover),
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
              ),

            /// Actions (Like, Comment, Bookmark)
            15.hS,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  padding: EdgeInsets.all(16.w),
                  onPressed: widget.onLike,
                  icon: Icon(
                    widget.isLiked ? Icons.favorite : Icons.favorite_border,
                    color:
                        widget.isLiked
                            ? Colors.red
                            : dark
                            ? AppColors.darkGrey
                            : AppColors.dark,
                  ),
                ),
                Row(
                  children: [
                    SvgPicture.asset("assets/icons/comment.svg", color: dark ? AppColors.darkGrey : AppColors.dark),
                    5.wS,
                    Text(widget.commentCount, style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
                  ],
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,

                  onTap: widget.onSave,
                  child: Container(
                    padding: EdgeInsets.all(16.w),
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
      ),
    );
  }
}
