// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_routes.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  OnboardingPageState createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final dark = Ui.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? AppColors.dark : Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: const [
              OnboardingContent(
                content: 'Unlock the secrets of digital marketing today',
                assetName: 'assets/images/onboarding1.svg',
                subContent: "Join us to discover essential digital marketing skills and elevate your career!",
              ),
              OnboardingContent(
                content: 'Choose from free and paid options tailored to your needs.',
                assetName: 'assets/images/onboarding2.svg',
                subContent:
                    "Browse our diverse courses designed for all skill levels, from beginners to advanced marketers.",
              ),
              OnboardingContent(
                content: 'Learn from experts and join a supportive community.',
                assetName: 'assets/images/onboarding3.svg',
                subContent:
                    "Gain valuable insights, network with peers, and receive guidance from industry professionals.",
              ),
              OnboardingContent(
                content: 'Sign up now and start your learning journey!',
                assetName: 'assets/images/onboarding4.svg',
                subContent: "Create your account today and unlock access to transformative learning experiences!",
              ),
            ],
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) => _buildIndicator(index == _currentPage)),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('hasSeenOnboarding', true);

              context.go(AppRoutes.signIn);
            },
            child: Text(
              'Login Now',
              style: GoogleFonts.lexend(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryColor : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String assetName;
  final String content;
  final String subContent;
  const OnboardingContent({super.key, required this.assetName, required this.content, required this.subContent});

  @override
  Widget build(BuildContext context) {
    final dark = Ui.isDarkMode(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            SizedBox(height: 50),
            SvgPicture.asset(assetName, height: 300),
            Text(
              content,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: dark ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Text(
              subContent,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: dark ? Colors.white : Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
