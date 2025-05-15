import 'package:stepup_community/core/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImagePickerWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function() onTap;
  const ImagePickerWidget({super.key, required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Material(
        child: Container(
          height: 40.h,
          decoration: BoxDecoration(
            color: const Color(0xFFE9F0FF),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.primaryColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5.w,
            children: [
              Icon(icon, size: 24, color: AppColors.primaryColor),
              Text(text, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14.sp)),
            ],
          ),
        ),
      ),
    );
  }
}
