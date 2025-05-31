import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stepup_community/core/utils/theme/colors.dart';
import 'package:stepup_community/features/course/widgets/course_card_widget.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> with SingleTickerProviderStateMixin {
  late final TabController _controller = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(context), body: _buildTabBarView());
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: const Text('Courses'),
      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.copy))],
      bottom: _buildTabBar(context),
    );
  }

  PreferredSizeWidget _buildTabBar(BuildContext context) {
    return TabBar(
      controller: _controller,
      unselectedLabelStyle: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: TColors.textPrimary),
      labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: TColors.primary),
      dividerColor: TColors.borderPrimary,
      indicatorColor: TColors.primary,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 0.5.h,
      indicatorPadding: EdgeInsets.symmetric(horizontal: 16.w),
      tabs: const [Tab(child: Text('All Courses')), Tab(child: Text('New Releases'))],
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(controller: _controller, children: const [_AllCoursesList(), _NewReleaseCourseList()]);
  }
}

class _AllCoursesList extends StatelessWidget {
  const _AllCoursesList();

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

class _NewReleaseCourseList extends StatelessWidget {
  const _NewReleaseCourseList();

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
