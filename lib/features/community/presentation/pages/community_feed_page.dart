// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CommunityFeedScreen extends StatelessWidget {
  final GoogleSignInAccount? user;
  const CommunityFeedScreen({super.key, this.user});

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  width: 40.w,
                  height: 5.h,
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                ),
                Text("Comments", style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700)),
                40.hS,
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      _buildComment(context, 'U1', 'User1', 'Nice post!', [
                        _buildComment(context, 'U3', 'User3', 'Thanks!', []),
                      ]),
                      _buildComment(context, 'U2', 'User2', 'Great picture!', []),
                      // ...additional comments...
                    ],
                  ),
                ),
                Divider(height: 1.h),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(child: Text('U')),
                      10.wS,
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(hintText: 'Add a comment...', border: InputBorder.none),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          // Handle comment submission
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildComment(
    BuildContext context,
    String avatarText,
    String userName,
    String commentText,
    List<Widget> replies,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(leading: CircleAvatar(child: Text(avatarText)), title: Text(userName), subtitle: Text(commentText)),
          TextButton(
            onPressed: () {
              // Handle reply action
            },
            child: Text('Reply', style: TextStyle(color: Colors.blue)),
          ),
          if (replies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: replies),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor, Color(0xFF003BC6)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(24.h),
          child: Container(color: Colors.grey[300], height: 1.h),
        ),
        title: Row(
          children: [
            SvgPicture.asset("assets/logo/bg_logo.svg"),
            10.wS,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('StepUp', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                Text('Community', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
        actionsPadding: EdgeInsets.only(right: 10.w),

        actions: [
          CircleAvatar(
            backgroundColor: Color(0xff2F60CF),
            child: IconButton(icon: Icon(Icons.notifications_outlined, color: Colors.white), onPressed: () {}),
          ),
          10.wS,
          CircleAvatar(
            backgroundColor: Color(0xff2F60CF),
            child: IconButton(icon: Icon(Icons.search, color: Colors.white), onPressed: () {}),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Color(0xffE9F0FF),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          Get.find<AuthController>().loginResponseModel.value.result?.user?.avatar ?? "",
                        ),
                      ),
                      10.wS,
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            context.push('/create-post');
                          },
                          style: TextButton.styleFrom(
                            alignment: Alignment.centerLeft,
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                            side: BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Text(
                            'Creatre a Post!',
                            style: GoogleFonts.plusJakartaSans(color: Colors.grey, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      14.wS,
                      IconButton(icon: Icon(Icons.add_circle_outline), onPressed: () {}),
                    ],
                  ),
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => SizedBox(height: 5.h),
                itemCount: 11, // Increased by 1 to include the create post section
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      context.push('/post-details', extra: index); // Navigate to post details page
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(child: Text('U$index')),
                              10.wS,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Fahmid Al Nayem',
                                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                                  ),
                                  Text('2 hours ago', style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
                                ],
                              ),
                              10.wS,
                              Text('Social Media', style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
                            ],
                          ),
                          15.hS,
                          Text('This is the caption for post $index'),
                          15.hS,
                          SizedBox(
                            height: 200.h,
                            child: Image.asset("assets/images/stepup_image.png", fit: BoxFit.cover),
                          ),
                          Row(
                            children: [
                              Icon(Icons.favorite_border),
                              5.wS,
                              Text('12', style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
                              10.wS,

                              SvgPicture.asset("assets/icons/comment.svg"),
                              5.wS,
                              Text('12', style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
                              const Spacer(),
                              IconButton(
                                icon: SvgPicture.asset("assets/icons/share.svg"),
                                onPressed: () {
                                  // Handle share action
                                },
                              ),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(shape: CircleBorder(), padding: EdgeInsets.all(5)),
                                onPressed: () {
                                  // Handle share action
                                },
                                child: Icon(Icons.bookmark_outline, color: Colors.amber, size: 24),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
