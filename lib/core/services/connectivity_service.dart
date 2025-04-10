import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  final RxBool isConnected = true.obs;
  Timer? _periodicTimer;

  @override
  void onInit() {
    super.onInit();
    _startMonitoring();
    _checkInitialConnection(); // Check once on app launch
  }

  void _startMonitoring() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) async {
      // Safely pick one result from the list (e.g., prioritize Wi-Fi > Mobile > None)
      final result =
          results.contains(ConnectivityResult.wifi)
              ? ConnectivityResult.wifi
              : results.contains(ConnectivityResult.mobile)
              ? ConnectivityResult.mobile
              : ConnectivityResult.none;

      final hasInternet = await _checkInternetConnection(result);
      _updateConnectionStatus(hasInternet);
    });
  }

  Future<void> _checkInitialConnection() async {
    final results = await _connectivity.checkConnectivity();

    final result =
        results.contains(ConnectivityResult.wifi)
            ? ConnectivityResult.wifi
            : results.contains(ConnectivityResult.mobile)
            ? ConnectivityResult.mobile
            : ConnectivityResult.none;

    final hasInternet = await _checkInternetConnection(result);
    _updateConnectionStatus(hasInternet);
  }


  Future<bool> _checkInternetConnection(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) return false;
    try {
      final lookupResult = await InternetAddress.lookup('google.com');
      return lookupResult.isNotEmpty && lookupResult[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void _updateConnectionStatus(bool hasInternet) {
    isConnected.value = hasInternet;
    if (!hasInternet) {
      Get.offAllNamed('/no-internet'); // Navigate to the No Internet screen
    }
  }

  Future<void> retryConnection() async {
    final results = await _connectivity.checkConnectivity();
    final result =
        results.contains(ConnectivityResult.wifi)
            ? ConnectivityResult.wifi
            : results.contains(ConnectivityResult.mobile)
            ? ConnectivityResult.mobile
            : ConnectivityResult.none;

    final hasInternet = await _checkInternetConnection(result);
    if (hasInternet) {
      Get.offAllNamed('/'); // Navigate back to the main workflow
    }
  }


  @override
  void onClose() {
    _subscription.cancel();
    _periodicTimer?.cancel();
    super.onClose();
  }
}
