import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stepup_community/core/utils/theme/colors.dart';
import 'package:stepup_community/features/course/widgets/play_pause_button.dart';

class VideoThumbnailCard extends StatelessWidget {
  const VideoThumbnailCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      height: 190.h,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.pexels.com/photos/1973270/pexels-photo-1973270.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
            ),
            Center(
              child: PlayPauseButton(
                isPlaying: false,
                onTap: () {},
                borderAndButtonColor: TColors.primary,
                backgroundColor: TColors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
