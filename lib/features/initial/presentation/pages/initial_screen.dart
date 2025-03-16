import 'package:business_application/features/auth/controller/auth_controller.dart';
import 'package:business_application/features/home/presentation/pages/home_page.dart';
import 'package:business_application/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:business_application/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:business_application/features/auth/presentation/pages/signin_page.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool _firstLaunch = true;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final firstLaunch = prefs.getBool('firstLaunch') ?? true;
    if (firstLaunch) {
      await prefs.setBool('firstLaunch', false);
    }
    setState(() {
      _firstLaunch = firstLaunch;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_firstLaunch) {
      return const OnboardingPage();
    } else {
      if (Get.find<AuthService>().currentUser.value.result?.token != null) {
        return const HomePage();
      } else {
        return const SignInPage();
      }
    }
  }
}
