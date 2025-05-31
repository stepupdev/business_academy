import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:stepup_community/core/utils/theme/colors.dart';

class CourseCardWidget extends StatelessWidget {
  const CourseCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () => context.pushNamed('courseDetails', params: {'courseId': '12345'}),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_CourseThumbnail(), Gap(22.h), _CourseInfo()],
          ),
        ),
      ),
    );
  }
}

class _CourseThumbnail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190.h,

      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r), color: Colors.grey),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Image.network(
          'https://images.unsplash.com/photo-1557838923-2985c318be48?q=80&w=3131&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        ),
      ),
    );
  }
}

class _CourseInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 0,
      leading: CircleAvatar(
        radius: 20.r,
        backgroundColor: Colors.grey,
        backgroundImage: const NetworkImage(
          'https://images.unsplash.com/photo-1683348858658-7c6b0eff2a16?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fGZlbWFsZSUyMGRvY3RvcnxlbnwwfHwwfHx8MA%3D%3D',
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Dr. John Doe', style: context.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),

              Row(
                children: [
                  Icon(Icons.access_time_outlined, color: TColors.success, size: 15.sp),
                  Gap(4.w),
                  Text(
                    '12h 45m',
                    style: context.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500, color: TColors.success),
                  ),
                ],
              ),
            ],
          ),
          Gap(5.h),
          Text(
            "Pacifiers: 3 things you need to know Ad Content for MAM",
            style: context.textTheme.bodyMedium?.copyWith(color: TColors.textPrimary, fontWeight: FontWeight.w600),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
