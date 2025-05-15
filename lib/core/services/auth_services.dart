import 'package:stepup_community/features/auth/data/login_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthService extends GetxService {
  final currentUser = LoginResponseModel().obs;
  late GetStorage _box;
  final used = false.obs;
  final isWelcomeFirst = false.obs;
  final logged = false.obs;
  final deviceToken = ''.obs;
  final userId = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final disableDateList = <String>[].obs;

  final languagekey = 'en_US'.obs;

  AuthService() {
    _box = GetStorage();
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    _box = GetStorage();
    getLogged();
    //getLanguage();
    //  getDeviceToken();

    // getUsed();
    getCurrentUser();
    getWelcomePageFirst();
    super.onInit();
  }

  setFirstUseOrNot() async {
    _box.write('used', true);
    getUsed();
  }

  setFirstWelcomeOrNot() async {
    _box.write('isWelComeFirstTime', true);
    getWelcomePageFirst();
  }

  setUserId() async {
    _box.write('userid', true);
    getUserId();
  }

  setPhone(phone) async {
    _box.write('phone', phone);
    getPhone();
  }

  setEmail(email) async {
    _box.write('email', email);
    getEmail();
  }

  setDisableDate(list) async {
    _box.write('disableDate', list);
    getDisableDate();
  }

  removeDisableDate() async {
    _box.remove('disableDate');
  }

  removeEmail() async {
    _box.remove('email');
  }

  removePhone() async {
    _box.remove('phone');
  }

  getUserId() {
    if (_box.hasData('userid')) {
      userId.value = _box.read('userid');
    }
  }

  getEmail() {
    if (_box.hasData('email')) {
      email.value = _box.read('email');
    }
  }

  getPhone() {
    if (_box.hasData('phone')) {
      phone.value = _box.read('phone');
    }
  }

  getDisableDate() {
    if (_box.hasData('disableDate')) {
      disableDateList.value = _box.read('disableDate');
    }
  }

  getUsed() {
    if (_box.hasData('used')) {
      used.value = _box.read('used');
    }
  }

  getWelcomePageFirst() {
    if (_box.hasData('isWelComeFirstTime')) {
      isWelcomeFirst.value = _box.read('isWelComeFirstTime');
    }
  }

  getLogged() {
    if (_box.hasData('logged')) {
      logged.value = _box.read('logged');
    }
  }

  setUser(LoginResponseModel user) async {
    _box.write('currentUser', user.toJson());
    getCurrentUser();
  }

  setLogged() async {
    _box.write('logged', true);
  }

  removeLogged() async {
    _box.remove('logged');
  }

  getCurrentUser() {
    if (_box.hasData('currentUser')) {
      currentUser.value = LoginResponseModel.fromJson(_box.read('currentUser'));
      debugPrint("${_box.read('currentUser')}");
    }
  }

  Future removeCurrentUser() async {
    currentUser.value = LoginResponseModel();
    await _box.remove('currentUser');
  }

  // bool get isAuth => currentUser.value.user!.accToken! == null ? false : true;

  //  String get apiToken => currentUser.value.user!.accToken!;

  getLanguage() async {
    languagekey.value = GetStorage().read<String>('language') ?? 'en_US';
  }

  // Future<void> getDeviceToken() async {
  //   deviceToken.value = await FirebaseMessaging.instance.getToken() ?? '';
  //
  //   debugPrint('AuthService.getDeviceToken:${deviceToken.value}');
  // }
}
