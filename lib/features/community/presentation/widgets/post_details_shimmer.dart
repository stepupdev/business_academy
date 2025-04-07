import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class PostDetailsShimmer extends StatelessWidget {
  const PostDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Ui.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title shimmer
              Shimmer.fromColors(
                baseColor: dark ? AppColors.dark : Colors.grey[300]!,
                highlightColor: dark ? AppColors.darkerGrey : Colors.grey[100]!,
                child: Container(width: double.infinity, height: 20.h, color: Colors.grey[300]),
              ),
              10.hS,
              // Meta info shimmer (author, date, etc.)
              Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: dark ? AppColors.dark : Colors.grey[300]!,
                    highlightColor: dark ? AppColors.darkerGrey : Colors.grey[100]!,
                    child: CircleAvatar(backgroundColor: Colors.grey[300], radius: 20),
                  ),
                  10.wS,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: dark ? AppColors.dark : Colors.grey[300]!,
                        highlightColor: dark ? AppColors.darkerGrey : Colors.grey[100]!,
                        child: Container(width: 100.w, height: 10.h, color: Colors.grey[300]),
                      ),
                      5.hS,
                      Shimmer.fromColors(
                        baseColor: dark ? AppColors.dark : Colors.grey[300]!,
                        highlightColor: dark ? AppColors.darkerGrey : Colors.grey[100]!,
                        child: Container(width: 60.w, height: 10.h, color: Colors.grey[300]),
                      ),
                    ],
                  ),
                ],
              ),
              15.hS,
              // Image shimmer
              Shimmer.fromColors(
                baseColor: dark ? AppColors.dark : Colors.grey[300]!,
                highlightColor: dark ? AppColors.darkerGrey : Colors.grey[100]!,
                child: Container(width: double.infinity, height: 200.h, color: Colors.grey[300]),
              ),
              15.hS,
              // Paragraphs shimmer
              Column(
                children: List.generate(
                  3,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Shimmer.fromColors(
                      baseColor: dark ? AppColors.dark : Colors.grey[300]!,
                      highlightColor: dark ? AppColors.darkerGrey : Colors.grey[100]!,
                      child: Container(width: double.infinity, height: 10.h, color: Colors.grey[300]),
                    ),
                  ),
                ),
              ),
              20.hS,
              // Action buttons shimmer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  3,
                  (index) => Shimmer.fromColors(
                    baseColor: dark ? AppColors.dark : Colors.grey[300]!,
                    highlightColor: dark ? AppColors.darkerGrey : Colors.grey[100]!,
                    child: Container(
                      width: 30.w,
                      height: 30.h,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
