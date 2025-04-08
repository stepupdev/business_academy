import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:business_application/core/config/app_colors.dart';

class CustomShimmer extends StatelessWidget {
  const CustomShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Ui.isDarkMode(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: dark ? AppColors.dark : Colors.grey[300]!,
            highlightColor: dark ? AppColors.darkerGrey : Colors.grey[100]!,
            child: Container(
              color: dark ? AppColors.grey : Color(0xffE9F0FF),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(backgroundColor: Colors.grey[300], radius: 20),
                  10.wS,
                  Expanded(
                    child: Container(
                      height: 40.h,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          12.hS,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              height: 25.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => SizedBox(width: 5.w),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: dark ? AppColors.dark : Colors.grey[300]!,
                    highlightColor: dark ? AppColors.darkerGrey : Colors.grey[100]!,
                    child: Container(
                      width: 80.w,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(50)),
                    ),
                  );
                },
              ),
            ),
          ),
          5.hS,
          Divider(thickness: 0.5, color: Colors.grey[200]),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => Container(height: 5.h, color: Colors.grey[200]),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: dark ? AppColors.dark : Colors.grey[300]!,
                highlightColor: dark ? AppColors.darkerGrey : Colors.grey[100]!,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
                  color: dark ? AppColors.dark : Color(0xffE9F0FF),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(backgroundColor: Colors.grey[300], radius: 20),
                          10.wS,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(width: 100.w, height: 10.h, color: Colors.grey[300]),
                              5.hS,
                              Container(width: 60.w, height: 10.h, color: Colors.grey[300]),
                            ],
                          ),
                        ],
                      ),
                      15.hS,
                      Container(width: double.infinity, height: 10.h, color: Colors.grey[300]),
                      15.hS,
                      Container(width: double.infinity, height: 200.h, color: Colors.grey[300]),
                      15.hS,
                      Row(
                        children: [
                          Container(width: 20.w, height: 20.h, color: Colors.grey[300]),
                          15.wS,
                          Container(width: 20.w, height: 20.h, color: Colors.grey[300]),
                          const Spacer(),
                          Container(width: 20.w, height: 20.h, color: Colors.grey[300]),
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
    );
  }
}
