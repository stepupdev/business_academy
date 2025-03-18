import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInPage extends GetView<AuthController> {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          return Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFFFFF), Color(0xFFDEF3FF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 75),
                    Image.asset('assets/logo/logoname.png', height: 24),
                    const SizedBox(height: 75),
                    Text(
                      "Sign up Now and start your",
                      style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "Learning Journey!",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xffA1A3AD),
                      ),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        controller.signInWithGoogle(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        minimumSize: const Size(double.infinity, 50),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/images/google.svg', height: 24),
                          const SizedBox(width: 10),
                          const Text('Continue with Google'),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    // Rich text for the terms and conditions
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'By signing up, you agree to our ',
                        style: GoogleFonts.lexend(fontSize: 12.sp, color: Color(0xffA1A3AD)),
                        children: [
                          TextSpan(
                            text: 'Terms and Conditions',
                            style: GoogleFonts.lexend(fontSize: 12.sp, color: AppColors.primaryColor),
                          ),
                          const TextSpan(text: ' and ', style: TextStyle(color: Color(0xffA1A3AD))),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: GoogleFonts.lexend(fontSize: 12.sp, color: AppColors.primaryColor),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text("Step Up Your Game,", style: GoogleFonts.lexend(fontSize: 14.sp)),
                    Text("Transform your Career!", style: GoogleFonts.lexend(fontSize: 14.sp, color: Colors.grey)),
                  ],
                ),
              ),
              if (controller.isLoading.value)
                Container(color: Colors.black.withOpacity(0.5), child: Center(child: CircularProgressIndicator())),
            ],
          );
        }),
      ),
    );
  }
}
