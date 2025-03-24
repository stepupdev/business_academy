import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/features/community/data/comments_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CommentWidget extends StatelessWidget {
  final String avatarUrl;
  final String userName;
  final String content;
  final List<CommentsResult> replies;
  final VoidCallback? onReply;

  const CommentWidget({
    super.key,
    required this.avatarUrl,
    required this.userName,
    required this.content,
    required this.replies,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.dm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          userName,
                          style: GoogleFonts.plusJakartaSans(fontSize: 14.sp, fontWeight: FontWeight.w700),
                        ),
                        10.wS,
                        Text('2 hours ago', style: GoogleFonts.plusJakartaSans(fontSize: 12.sp, color: Colors.grey)),
                      ],
                    ),
                    10.hS,
                    Text(content, style: GoogleFonts.plusJakartaSans(fontSize: 12.sp)),
                    10.hS,

                    if (onReply != null)
                      InkWell(
                        onTap: onReply,
                        child: Text('Reply', style: TextStyle(color: Colors.blue, fontSize: 12.sp)),
                      ),
                  ],
                ),
              ),
            ],
          ),
          15.hS,
          if (replies.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    replies.map((reply) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(backgroundImage: NetworkImage(reply.user?.avatar ?? ''), radius: 15.r),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        reply.user?.name ?? '',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      5.wS,
                                      Text(
                                        '1 hour ago',
                                        style: GoogleFonts.plusJakartaSans(fontSize: 10.sp, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  5.hS,
                                  Text(reply.content ?? '', style: GoogleFonts.plusJakartaSans(fontSize: 11.sp)),
                                  5.hS,
                                  if (onReply != null)
                                    InkWell(
                                      onTap: onReply,
                                      child: Text('Reply', style: TextStyle(color: Colors.blue, fontSize: 11.sp)),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

// class ReplyWidget extends StatelessWidget {
//   final String avatarUrl;
//   final String userName;
//   final String content;

//   final VoidCallback? onReply;
//   const ReplyWidget({super.key, required this.avatarUrl, required this.userName, required this.content, this.onReply});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CircleAvatar(backgroundImage: NetworkImage(avatarUrl), radius: 15.r),
//         SizedBox(width: 10.w),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(userName, style: GoogleFonts.plusJakartaSans(fontSize: 12.sp, fontWeight: FontWeight.bold)),
//               Text(content, style: GoogleFonts.plusJakartaSans(fontSize: 11.sp)),
//               if (onReply != null)
//                 InkWell(onTap: onReply, child: Text('Reply', style: TextStyle(color: Colors.blue, fontSize: 12.sp))),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
