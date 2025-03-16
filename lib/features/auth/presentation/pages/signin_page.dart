import 'package:business_application/features/auth/controller/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends GetView<AuthController> {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> _handleSignIn() async {
      try {
        final user = await controller.signInWithGoogle();
        print("user: $user");
        if (user != null) {
          context.go('/home', extra: user);
        }
        if (user == null) {
          print("null");
        }
      } catch (error) {
        print("Hello");
        print(error);
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
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
                style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xffA1A3AD)),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _handleSignIn,
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
                text: TextSpan(
                  text: 'By signing up, you agree to our ',
                  style: GoogleFonts.lexend(fontSize: 14, color: Color(0xffA1A3AD)),
                  children: [
                    TextSpan(
                      text: 'Terms and Conditions',
                      style: GoogleFonts.lexend(fontSize: 14, color: Color(0xff205EEF)),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text("Step Up Your Game,", style: GoogleFonts.lexend(fontSize: 14)),
              Text("Transform your Career!", style: GoogleFonts.lexend(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
