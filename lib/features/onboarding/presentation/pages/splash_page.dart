import 'package:business_application/core/config/app_routes.dart';
import 'package:business_application/core/services/connectivity_service.dart';
import 'package:business_application/core/utils/auth_utils.dart';
import 'package:business_application/core/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginState();
  }

  Future<void> _checkLoginState() async {
    await Future.delayed(const Duration(seconds: 2)); // Splash delay

    bool isLoggedIn = await AuthUtlity.checkUserLogin();
    final isConnect = await Get.find<ConnectivityService>().checkNow();
    if (!isConnect) {
      debugPrint("No internet connection");
      context.go(AppRoutes.noInternet);
      return;
    }
    debugPrint("🔹 Is User Logged In? $isLoggedIn");

    if (isLoggedIn) {
      debugPrint("✅ Redirecting to Home Page...");
      context.go(AppRoutes.communityFeed);
      await Get.find<AuthService>().getCurrentUser();
    } else {
      debugPrint("❌ Redirecting to Sign-In Page...");
      context.go(AppRoutes.signIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Center(child: SvgPicture.asset('assets/logo/logo.svg', height: 80)),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Text("Step Up Your Game,", style: GoogleFonts.lexend(fontSize: 14)),
                  Text("Transform Your Career!", style: GoogleFonts.lexend(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
