import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stepup_community/core/config/app_colors.dart';
import 'package:stepup_community/core/config/app_size.dart';
import 'package:stepup_community/core/utils/ui_support.dart';
import 'package:stepup_community/features/community/controller/community_controller.dart';
import 'package:stepup_community/features/video_player/presentation/page/yt_video_player.dart';

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
    this.onCommentTap,
    required this.commentCount,
    required this.likesCount,
    required this.isLiked,
    required this.isSaved,
    this.onLike,
    this.onSave,
    this.onTopicTap, // Add this line
  });

  final VoidCallback onTap;
  final VoidCallback? onLike;
  final VoidCallback? onSave;
  final VoidCallback? onCommentTap;
  final VoidCallback? onTopicTap; // Add this line
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
  final String likesCount;
  final bool isLiked;
  final bool isSaved;
  @override
  State<PostDetailsCard> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetailsCard> {
  // bool _isExpanded = false;
  // bool _isOverflowing = false;
  String? videoThumbnail;

  String? getVideoThumbnail(String? videoUrl) {
    if (videoUrl == null || videoUrl.isEmpty) return null;
    Uri uri = Uri.parse(videoUrl);
    String videoId = uri.queryParameters['v'] ?? uri.pathSegments.last;
    return "https://i.ytimg.com/vi/$videoId/hqdefault.jpg";
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _checkOverflow();
    // });
    videoThumbnail = getVideoThumbnail(widget.videoUrl);
  }

  // void _checkOverflow() {
  //   final textSpan = TextSpan(
  //     text: Get.find<CommunityController>().cleanHtml(widget.caption),
  //     style: GoogleFonts.plusJakartaSans(),
  //   );
  //   final textPainter = TextPainter(text: textSpan, maxLines: 3, textDirection: TextDirection.ltr)
  //     ..layout(maxWidth: MediaQuery.of(context).size.width - 20.w);

  //   setState(() {
  //     _isOverflowing = textPainter.didExceedMaxLines;
  //   });
  // }

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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        color: dark ? const Color(0xFF1A1A1A) : Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// User Info
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryColor.withOpacity(0.3), width: 1.5),
                  ),
                  child: CircleAvatar(radius: 20.r, backgroundImage: NetworkImage(widget.dp)),
                ),
                12.wS,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.name,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 15.sp,
                                color: dark ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                          if (widget.rank.isNotEmpty) ...[
                            8.wS,
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppColors.primaryColor, const Color(0xFF003BC6)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.rank,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      4.hS,
                      Row(
                        children: [
                          Text(widget.time, style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 12.sp)),
                          8.wS,
                          Container(
                            width: 3.w,
                            height: 3.w,
                            decoration: BoxDecoration(color: Colors.grey.shade400, shape: BoxShape.circle),
                          ),
                          8.wS,
                          GestureDetector(
                            onTap: widget.onTopicTap,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                widget.topic,
                                style: GoogleFonts.inter(
                                  color: AppColors.primaryColor,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            /// Caption
            if (widget.caption.isNotEmpty) ...[
              16.hS,
              Text(
                Get.find<CommunityController>().cleanHtml(widget.caption),
                style: GoogleFonts.inter(color: dark ? Colors.white : Colors.black87, fontSize: 14.sp, height: 1.4),
              ),
            ],

            /// Post Image/Video Thumbnail with Play Icon
            if (widget.postImage!.isNotEmpty || widget.videoUrl!.isNotEmpty) ...[
              12.hS,
              // Make only images edge-to-edge, keep videos with padding
              widget.postImage!.isNotEmpty
                  ? Transform.translate(
                    offset: Offset(-16.w, 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: GestureDetector(
                        onTap: widget.onTap,
                        child: ClipRRect(
                          child: Image.network(
                            widget.postImage!,
                            width: double.infinity,
                            height: 200.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  )
                  : widget.videoUrl!.isNotEmpty
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => YouTubeVideoPlayer(videoUrl: widget.videoUrl!)),
                        );
                      },
                      child: Stack(
                        children: [
                          Image.network(videoThumbnail!, width: double.infinity, height: 200.h, fit: BoxFit.cover),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.play_arrow, color: AppColors.primaryColor, size: 32.sp),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  : const SizedBox(),
            ],

            /// Actions (Like, Comment, Bookmark)
            16.hS,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(
                  icon: widget.isLiked ? Icons.favorite : Icons.favorite_border,
                  count: widget.likesCount,
                  isActive: widget.isLiked,
                  activeColor: Colors.red,
                  onTap: widget.onLike,
                ),
                _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  count: widget.commentCount,
                  onTap: widget.onCommentTap,
                ),
                _buildActionButton(
                  icon: widget.isSaved ? Icons.bookmark : Icons.bookmark_border,
                  isActive: widget.isSaved,
                  activeColor: Colors.amber,
                  onTap: widget.onSave,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    String? count,
    bool isActive = false,
    Color? activeColor,
    VoidCallback? onTap,
  }) {
    final dark = Ui.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color:
                  isActive && activeColor != null
                      ? activeColor
                      : dark
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
              size: 20.sp,
            ),
            if (count != null) ...[
              6.wS,
              Text(
                count,
                style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
