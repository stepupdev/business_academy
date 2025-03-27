import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/core/utils/helper_utils.dart';
import 'package:business_application/features/community/data/comments_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CommentWidget extends StatelessWidget {
  final String avatarUrl;
  final String userName;
  final String rank;
  final String time;
  final String content;
  final List<CommentsResult> replies;
  final VoidCallback? onReply;
  final VoidCallback? onDelete;

  const CommentWidget({
    super.key,
    required this.avatarUrl,
    required this.userName,
    required this.time,
    required this.rank,
    required this.content,
    required this.replies,
    required this.onDelete,
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
                        Container(
                          margin: EdgeInsets.only(left: 5.w),
                          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withAlpha(200),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(rank, style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 10.sp)),
                        ),
                      ],
                    ),
                    10.hS,
                    Text(content, style: GoogleFonts.plusJakartaSans(fontSize: 12.sp)),
                    10.hS,

                    Row(
                      children: [
                        Expanded(
                          child: Text(time, style: GoogleFonts.plusJakartaSans(fontSize: 10.sp, color: Colors.grey)),
                        ),
                        if (onReply != null)
                          TextButton(
                            onPressed: onReply,
                            child: Text('Reply', style: TextStyle(color: Colors.blue, fontSize: 12.sp)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              // 3 dot for show popup menu for delete the comments
              PopupMenuButton(
                itemBuilder: (context) => [PopupMenuItem(value: 'delete', child: Text('Delete'))],
                onSelected: (value) {
                  if (value == 'delete') {
                    onDelete?.call();
                  }
                },
              ),
            ],
          ),
          15.hS,
          if (replies.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Column(
                // Replace Expanded with Column
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    replies.map((reply) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                      Container(
                                        margin: EdgeInsets.only(left: 5.w),
                                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor.withAlpha(200),
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: Text(
                                          rank,
                                          style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 10.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                  5.hS,
                                  Text(reply.content ?? '', style: GoogleFonts.plusJakartaSans(fontSize: 11.sp)),
                                  5.hS,
                                  if (onReply != null)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            HelperUtils.formatTime(reply.createdAt ?? DateTime.now()),
                                            style: GoogleFonts.plusJakartaSans(fontSize: 10.sp, color: Colors.grey),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: onReply,
                                          child: Text('Reply', style: TextStyle(color: Colors.blue, fontSize: 11.sp)),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                            PopupMenuButton(
                              itemBuilder: (context) => [PopupMenuItem(value: 'delete', child: Text('Delete'))],
                              onSelected: (value) {
                                if (value == 'delete') {
                                  onDelete?.call();
                                }
                              },
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
