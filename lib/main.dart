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

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void checkNotifications(SendPort sendPort) async {
  while (true) {
    sendPort.send("check_notifications");
    await Future.delayed(Duration(seconds: 30));
  }
}

void startNotificationChecker() async {
  ReceivePort receivePort = ReceivePort();
  await Isolate.spawn(checkNotifications, receivePort.sendPort);

  receivePort.listen((message) async {
    if (message == "check_notifications") {
      bool hasNewNotifications = await Get.find<NotificationController>().checkNotification();

      if (hasNewNotifications) {
        print("🔔 New notification received!");
      }
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          scaffoldMessengerKey: scaffoldMessengerKey,
          routerDelegate: AppRouter.router.routerDelegate, // Use GoRouter's routerDelegate
          routeInformationParser: AppRouter.router.routeInformationParser, // Use GoRouter's routeInformationParser
          routeInformationProvider:
              AppRouter.router.routeInformationProvider, // Use GoRouter's routeInformationProvider
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
