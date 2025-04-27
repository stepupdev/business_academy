import 'dart:convert';
import 'package:business_application/features/auth/data/login_response_model.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUtlity {
  AuthUtlity._();

  static LoginResponseModel userInfo = LoginResponseModel();

  /// ✅ **Save user token and ID properly**
  static Future<void> saveUserIdAndToken(String userId, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
    await prefs.setString('token', token);
    debugPrint("✅ Token Saved: $token"); // Debug log
  }

  /// ✅ **Retrieve token and log it**
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      debugPrint("⚠️ No token found in storage.");
      return null;
    }

    debugPrint("✅ Retrieved Token: $token");
    return token;
  }

  /// ✅ **Save user information**
  static Future<void> saveUserInfo(LoginResponseModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user-data', jsonEncode(model.toJson()));
    userInfo = model;
    debugPrint("✅ User info saved.");
  }

  /// ✅ **Retrieve user info with proper handling**
  static Future<LoginResponseModel?> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString('user-data');

    if (value == null) {
      debugPrint("⚠️ No user data found.");
      return null;
    }

    debugPrint("✅ Retrieved User Info: $value");
    return LoginResponseModel.fromJson(jsonDecode(value));
  }

  /// ✅ **Check login status before opening the app**
  static Future<bool> checkUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool hasUserData = prefs.containsKey('user-data');
    String? token = prefs.getString('token');

    debugPrint("🔍 Checking Login State...");
    debugPrint("📌 Has User Data: $hasUserData");
    debugPrint("📌 Retrieved Token: $token");

    // 🔹 Check Google Sign-In
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleUser = await googleSignIn.signInSilently();

    if (token != null && token.isNotEmpty) {
      debugPrint("✅ User is logged in with token.");
      userInfo = await getUserInfo() ?? LoginResponseModel();
      return true;
    }

    if (googleUser != null) {
      debugPrint("✅ User is logged in with Google Sign-In.");
      return true;
    }

    debugPrint("❌ User is NOT logged in.");
    return false;
  }
  static Future<bool> checkSeenOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    debugPrint("🔍 Checking Onboarding State: $hasSeenOnboarding");
    return hasSeenOnboarding;
  }

  // remove user data
  static Future<void> removeUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user-data');
    await prefs.remove('token');
    debugPrint("✅ User data removed.");
  }
}
