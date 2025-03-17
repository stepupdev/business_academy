import 'package:business_application/features/auth/presentation/pages/signin_page.dart';
import 'package:business_application/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      return const SignInPage();
    }
  }
}
