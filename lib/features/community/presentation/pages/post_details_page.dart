import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PostDetailsPage extends StatefulWidget {
  final int postIndex;
  const PostDetailsPage({super.key, required this.postIndex});

  @override
  PostDetailsPageState createState() => PostDetailsPageState();
}

class PostDetailsPageState extends State<PostDetailsPage> {
  final TextEditingController _commentController = TextEditingController();
  bool _isReplying = false;

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
      appBar: AppBar(title: Text('Post Details')),
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
                    SizedBox(height: 200.h, child: Image.asset("assets/images/stepup_image.png", fit: BoxFit.cover)),
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
              if (_isReplying)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(hintText: 'Write a reply...', border: OutlineInputBorder()),
                  ),
                ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Row(
                  children: [
                    CircleAvatar(radius: 25.r, child: Text('FN')),
                    10.wS,
                    Expanded(
                      child: TextFormField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: AppColors.borderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: AppColors.borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
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
