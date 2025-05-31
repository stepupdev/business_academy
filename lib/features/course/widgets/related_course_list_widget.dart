import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stepup_community/features/course/widgets/course_card_widget.dart';

class RelatedCourseListWidget extends StatelessWidget {
  const RelatedCourseListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      itemCount: 10,
      shrinkWrap: true,
      prototypeItem: const CourseCardWidget(),
      itemBuilder: (context, index) => CourseCardWidget(),
    );
  }
}
