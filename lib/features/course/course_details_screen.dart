import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:stepup_community/core/utils/theme/colors.dart';
import 'package:stepup_community/features/course/widgets/lesson_list_widget.dart';
import 'package:stepup_community/features/course/widgets/product_list_widget.dart';
import 'package:stepup_community/features/course/widgets/related_course_list_widget.dart';
import 'package:stepup_community/features/course/widgets/video_thumbnail.dart';

class CourseDetailsScreen extends StatefulWidget {
  final String courseId;
  const CourseDetailsScreen({super.key, required this.courseId});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 3, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: NestedScrollView(
        headerSliverBuilder:
            (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(child: _buildHeaderContent()),
              _buildPinnedTabBar(context),
            ],
        body: _buildTabBarView(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text('Course Details'),
      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.copy))],
    );
  }

  Widget _buildHeaderContent() {
    return Column(children: const [VideoThumbnailCard(), Gap(18), _CourseInfo()]);
  }

  SliverAppBar _buildPinnedTabBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      automaticallyImplyLeading: false,
      toolbarHeight: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: TabBar(
            controller: _tabController,
            labelStyle: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: TColors.textPrimary,
            ),
            unselectedLabelStyle: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: TColors.textPrimary
            ),
            dividerColor: TColors.borderPrimary,
            indicatorColor: TColors.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 0.5.h,
            indicatorPadding: EdgeInsets.symmetric(horizontal: 16.w),
            tabs: const [Tab(text: 'Lessons (12)'), Tab(text: 'Related'), Tab(text: 'Resources')],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [LessonListWidget(), RelatedCourseListWidget(), ProductListWidget()],
    );
  }
}

class _CourseInfo extends StatelessWidget {
  const _CourseInfo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [_InstructorInfo(), Gap(20), _CourseDescription(), Gap(16)],
      ),
    );
  }
}

class _InstructorInfo extends StatelessWidget {
  const _InstructorInfo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(radius: 20.r),
            Gap(10.w),
            Text(
              'Dr. Rohman Khan',
              style: context.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            ),
            Gap(10.w),
            const Icon(Icons.access_time, color: TColors.success),
            Gap(5.w),
            Text(
              '12h 45m',
              style: context.textTheme.bodySmall?.copyWith(fontSize: 10.sp, color: TColors.success),
            ),
          ],
        ),
        IconButton(onPressed: () {}, icon: Icon(Icons.bookmark, color: TColors.borderPrimary)),
      ],
    );
  }
}

class _CourseDescription extends StatelessWidget {
  const _CourseDescription();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Baby's Brain Development & Motor Skills Enhancing Activities",
          style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        Gap(16.h),
        Text(
          "Make best use of the first 1000 days of baby's life which are crucial for neural development and language nutrition",
          style: context.textTheme.bodySmall,
        ),
      ],
    );
  }
}

// class _CourseTags extends StatelessWidget {
//   const _CourseTags();

//   @override
//   Widget build(BuildContext context) {
//     final tags = ['Pregnancy series', 'education'];
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Wrap(
//         spacing: 8.w,
//         runSpacing: 8.h,
//         children: tags.map((tag) => TagChipWidget(label: tag)).toList(),
//       ),
//     );
//   }
// }
