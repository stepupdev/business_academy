import 'dart:isolate';

import 'package:business_application/core/config/app_router.dart';
import 'package:business_application/core/config/dependency_injection.dart';
import 'package:business_application/core/services/auth_services.dart';
import 'package:business_application/core/utils/theme/theme.dart';
import 'package:business_application/features/notification/controller/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    Get.find<NotificationController>().checkNotification();
    return Future.value(true);
  });
}

void checkNotifications(SendPort sendPort) async {
  while (true) {
    // Simulate API call to check for notifications
    bool hasNewNotifications = await Get.find<NotificationController>().checkNotification();
    sendPort.send(hasNewNotifications);

    // Wait for 10 seconds before checking again
    await Future.delayed(Duration(seconds: 10));
  }
}

void startNotificationChecker() async {
  ReceivePort receivePort = ReceivePort();
  await Isolate.spawn(checkNotifications, receivePort.sendPort);

  receivePort.listen((message) {
    if (message == true) {
      print("🔔 New notification received!");
      // You can trigger a local notification here
    }
  });
}

void main() async {
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerPeriodicTask("checkNotifications", "fetchNotifications", frequency: Duration(minutes: 2));
  await Get.putAsync(() async => AuthService());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(const MyApp());
    startNotificationChecker();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp.router(
          debugShowCheckedModeBanner: false,
          routeInformationParser: AppRouter.router.routeInformationParser,
          routerDelegate: AppRouter.router.routerDelegate,
          routeInformationProvider: AppRouter.router.routeInformationProvider,
          title: 'Business Academy',
          theme: TAppTheme.lightTheme,
          themeMode: ThemeMode.system,
          darkTheme: TAppTheme.darkTheme,
          initialBinding: DependencyInjection(),
        );
      },
    );
  }
}
