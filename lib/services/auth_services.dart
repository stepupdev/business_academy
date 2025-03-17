import 'dart:convert';

import 'package:business_application/features/auth/data/login_response_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  final currentUser = LoginResponseModel().obs;
  late SharedPreferences _prefs;
  final logged = false.obs;

  @override
  void onInit() async {
    super.onInit();
    _prefs = await SharedPreferences.getInstance();
    getCurrentUser();
  }

  setUser(LoginResponseModel user) async {
    await _prefs.setString('currentUser', user.toJson().toString());
    getCurrentUser();
  }

  setLogged() async {
    await _prefs.setBool('logged', true);
  }

  removeLogged() async {
    await _prefs.remove('logged');
  }

  getCurrentUser() {
    if (_prefs.containsKey('currentUser')) {
      currentUser.value = LoginResponseModel.fromJson(jsonDecode(_prefs.getString('currentUser') ?? '{}'));
      print("${_prefs.getString('currentUser')}");
    }
    print('customer data: ${currentUser.value.result?.user?.id}');
  }

  Future removeCurrentUser() async {
    currentUser.value = LoginResponseModel();
    await _prefs.remove('currentUser');
  }
}
