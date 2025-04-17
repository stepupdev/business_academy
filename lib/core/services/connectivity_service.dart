import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxController {
  static ConnectivityService get instance => Get.find();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final RxBool isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnection();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((_) {
      _checkInitialConnection();
    });
  }

  Future<void> _checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    await _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    final hasConnection = result.any((element) => element != ConnectivityResult.none);
    isConnected.value = hasConnection;
  }

  Future<bool> checkNow() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      return result != ConnectivityResult.none;
    } on PlatformException {
      return false;
    }
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
