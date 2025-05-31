import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stepup_community/core/utils/theme/colors.dart';

class LessonListWidget extends StatelessWidget {
  const LessonListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      itemBuilder: (context, index) => _LessonWidget(),
      separatorBuilder:
          (context, index) => Divider(height: 30.h, thickness: 0.5, endIndent: 16.w, indent: 16.w),
      itemCount: 12,
    );
  }
}

class _LessonWidget extends StatelessWidget {
  const _LessonWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        spacing: 16.w,
        children: [
          Icon(Icons.videocam_outlined, color: TColors.primary),
          Text(
            'Lesson 1: Introduction to Flutter',
          ),
        ],
      ),
    );
  }
}
