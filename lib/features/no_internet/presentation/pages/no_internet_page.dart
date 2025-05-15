import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:stepup_community/core/config/app_routes.dart';
import 'package:stepup_community/core/services/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_off, size: 80, color: Colors.redAccent),
              const SizedBox(height: 20),
              Text("No Internet Connection", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(
                "Please check your network settings and try again.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Get.find<ConnectivityService>().checkNow().then((isConnected) {
                    if (isConnected) {
                      context.go(AppRoutes.communityFeed);
                    } else {
                      if (Platform.isAndroid) {
                        AppSettings.openAppSettingsPanel(AppSettingsPanelType.internetConnectivity);
                      } else if (Platform.isIOS) {
                        AppSettings.openAppSettings();
                      }
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text("Retry"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
