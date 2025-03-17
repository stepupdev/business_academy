import 'dart:convert';

import 'package:business_application/features/auth/data/login_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUtlity {
  AuthUtlity._();

  static LoginResponseModel userInfo = LoginResponseModel();

  static Future<void> saveUserIdAndToken(String userId, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
    await prefs.setString('token', token);
  }

  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }


  static Future<void> saveUserInfo(LoginResponseModel model) async {
    SharedPreferences _sharep = await SharedPreferences.getInstance();
    await _sharep.setString('user-data', jsonEncode(model.toJson()));
    userInfo = model;
  }

  static Future<void> updateUserInfo(User data) async {
    SharedPreferences _sharep = await SharedPreferences.getInstance();
    userInfo.result?.user = data;
    await _sharep.setString('user-data', jsonEncode(userInfo.toJson()));
  }

  static Future<LoginResponseModel> getUserInfo() async {
    SharedPreferences _sharep = await SharedPreferences.getInstance();
    String value = await _sharep.getString('user-data')!;
    return LoginResponseModel.fromJson(jsonDecode(value));
  }

  static Future<void> clearInfo() async {
    SharedPreferences _sharep = await SharedPreferences.getInstance();
    _sharep.clear();
  }

  static Future<bool> checkuserlogin() async {
    SharedPreferences _sharep = await SharedPreferences.getInstance();
    bool islogin = _sharep.containsKey('user-data');

    if (islogin) {
      userInfo = await getUserInfo();
    }
    return islogin;
  }
}