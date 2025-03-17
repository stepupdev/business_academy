import 'package:business_application/core/config/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PostDetailsPage extends StatelessWidget {
  final int postIndex;
  const PostDetailsPage({super.key, required this.postIndex});

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
                margin: EdgeInsets.all(10.w),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(child: Text('U$postIndex')),
                      title: Text('User $postIndex'),
                      subtitle: Text('2 hours ago'), // Example timestamp
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('This is the caption for post $postIndex'),
                    ),
                    SizedBox(
                      height: 200.h,
                      child:
                          postIndex % 3 == 0
                              ? Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 5.h),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Center(child: Text('Photo 1')),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Center(child: Text('Photo 2')),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  5.wS,
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(child: Text('Photo 3')),
                                    ),
                                  ),
                                ],
                              )
                              : postIndex % 2 == 0
                              ? Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 5.w),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(child: Text('Photo 1')),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(child: Text('Photo 2')),
                                    ),
                                  ),
                                ],
                              )
                              : Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(child: Text('Photo $postIndex')),
                              ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.favorite_border),
                            onPressed: () {
                              // Handle like action
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.comment),
                            onPressed: () {
                              // Handle comment action
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1.h),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Comments", style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700)),
              ),
              _buildComment(context, 'U1', 'User1', 'Nice post!', [
                _buildComment(context, 'U3', 'User3', 'Thanks!', []),
              ]),
              _buildComment(context, 'U2', 'User2', 'Great picture!', []),
              // ...additional comments...
            ],
          ),
        ),
      ),
    );
  }
}
