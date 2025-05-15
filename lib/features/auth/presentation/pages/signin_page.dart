import 'package:stepup_community/core/config/app_colors.dart';
import 'package:stepup_community/core/services/connectivity_service.dart';
import 'package:stepup_community/core/utils/ui_support.dart';
import 'package:stepup_community/features/auth/controller/auth_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInPage extends GetView<AuthController> {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Ui.isDarkMode(context);

    // Function to launch a URL
    Future<void> _launchUrl(String url) async {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Ui.showErrorSnackBar(context, message: "Could not launch $url");
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          return Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: dark ? [AppColors.dark, AppColors.darkerGrey] : [Color(0xFFFFFFFF), Color(0xFFDEF3FF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 75),
                    Container(
                      decoration: BoxDecoration(
                        color: dark ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Image.asset('assets/logo/logoname.png', height: 24),
                    ),
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
                      onPressed: () async {
                        final isConnect = Get.find<ConnectivityService>().isConnected();
                        final networkService = Get.find<ConnectivityService>();
                        if (networkService.isConnected.value) {
                          debugPrint("Internet connection is available");
                        } else {
                          debugPrint("No internet connection");
                        }
                        if (!isConnect) {
                          debugPrint("No internet connection");
                          Ui.showErrorSnackBar(context, message: "No internet connection");
                          return;
                        }

                        controller.signInWithGoogle(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: dark ? AppColors.dark : Colors.white,
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
                          Text('Continue with Google', style: TextStyle(color: dark ? Colors.white : Colors.black)),
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
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    _launchUrl('https://stepup.com.bd'); // Replace with your Terms URL
                                  },
                          ),
                          const TextSpan(text: ' and ', style: TextStyle(color: Color(0xffA1A3AD))),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: GoogleFonts.lexend(fontSize: 12.sp, color: AppColors.primaryColor),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    _launchUrl('https://stepup.com.bd'); // Replace with your Privacy Policy URL
                                  },
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
