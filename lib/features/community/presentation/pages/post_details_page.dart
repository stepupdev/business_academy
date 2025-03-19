import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/features/video_player/presentation/page/yt_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PostDetailsPage extends StatefulWidget {
  final bool isVideo;
  const PostDetailsPage({super.key, this.isVideo = true});

  @override
  PostDetailsPageState createState() => PostDetailsPageState();
}

class PostDetailsPageState extends State<PostDetailsPage> {
  final TextEditingController _commentController = TextEditingController();
  bool _isReplying = false;
  String? _replyingTo;

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, title: Text('Post Details')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(child: Text('FN')),
                        10.wS,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Fahmid Al Nayem', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                            Text('2 hours ago', style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
                          ],
                        ),
                        10.wS,
                        Text('Social Media', style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
                      ],
                    ),
                    15.hS,
                    Text('This is the caption for post index'),
                    15.hS,
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return YouTubeVideoPlayer(videoUrl: "https://www.youtube.com/watch?v=lqQjZOTuVBY");
                            },
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 200.h,
                        width: double.infinity,
                        child:
                            widget.isVideo
                                ? Stack(
                                  children: [
                                    Image.network(
                                      "https://i.ytimg.com/vi/lqQjZOTuVBY/hqdefault.jpg",
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                    Center(child: Icon(Icons.play_circle_fill, color: Colors.white, size: 50.r)),
                                  ],
                                )
                                : Image.asset("assets/images/stepup_image.png", fit: BoxFit.cover),
                      ),
                    ),
                    15.hS,
                    Row(
                      children: [
                        Icon(Icons.favorite_border),
                        15.wS,
                        SvgPicture.asset("assets/icons/comment.svg"),
                        5.wS,
                        Text('12', style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
                        const Spacer(),
                        Icon(Icons.bookmark_outline, color: Colors.amber, size: 24),
                      ],
                    ),
                  ],
                ),
              ),
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
      ),
    );
  }
}
