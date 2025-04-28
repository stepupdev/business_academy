import 'dart:isolate';

import 'package:business_application/core/config/app_router.dart';
import 'package:business_application/core/config/dependency_injection.dart';
import 'package:business_application/core/services/auth_services.dart';
import 'package:business_application/core/services/connectivity_service.dart';
import 'package:business_application/core/utils/app_strings.dart';
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

Future<void> startNotificationChecker(BuildContext context) async {
  ReceivePort receivePort = ReceivePort();
  await Isolate.spawn(checkNotifications, receivePort.sendPort);

  receivePort.listen((message) async {
    if (message == "check_notifications") {
      var hasNewNotifications = await Get.find<NotificationController>().checkNotification(context);

      if (hasNewNotifications) {
        debugPrint("🔔 New notification received!");
      }
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ConnectivityService());
  await Get.putAsync(() async => AuthService());
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: Colors.transparent,
  //     statusBarIconBrightness: Brightness.dark,
  //     statusBarBrightness: Brightness.dark,
  //     systemNavigationBarColor: Colors.white,
  //     systemNavigationBarIconBrightness: Brightness.dark,
  //   ),
  // );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) async {
    runApp(const MyApp());
    await startNotificationChecker(Get.context!);
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setSystemUIOverlayStyle();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    _setSystemUIOverlayStyle();
  }

  void _setSystemUIOverlayStyle() {
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final isDark = brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: isDark ? Colors.black : Colors.white,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }

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
          routerDelegate: AppRouter.router.routerDelegate,
          routeInformationParser: AppRouter.router.routeInformationParser,
          routeInformationProvider: AppRouter.router.routeInformationProvider,
          title: AppStrings.appName,
          theme: TAppTheme.lightTheme,
          themeMode: ThemeMode.system,
          darkTheme: TAppTheme.darkTheme,
          initialBinding: DependencyInjection(),
        );
      },
    );
  }
}
