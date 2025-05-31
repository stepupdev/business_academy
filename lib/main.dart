import 'dart:async';

import 'package:stepup_community/core/config/app_router.dart';
import 'package:stepup_community/core/config/dependency_injection.dart';
import 'package:stepup_community/core/services/auth_services.dart';
import 'package:stepup_community/core/services/connectivity_service.dart';
import 'package:stepup_community/core/utils/app_strings.dart';
import 'package:stepup_community/core/utils/theme/theme.dart';
import 'package:stepup_community/features/notification/controller/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

// Replace the isolate-based approach with a Timer-based approach
Timer? _notificationTimer;

Future<void> startNotificationChecker() async {
  // Stop any existing timer first
  stopNotificationChecker();

  debugPrint("🔔 Starting notification checker...");

  // Use Timer.periodic instead of isolate for better integration with GetX
  _notificationTimer = Timer.periodic(Duration(seconds: 30), (timer) async {
    try {
      // Check if user is still authenticated
      final authService = Get.find<AuthService>();
      if (authService.currentUser.value.result?.token == null) {
        debugPrint("⚠️ User not authenticated, stopping notification checker");
        stopNotificationChecker();
        return;
      }

      var hasNewNotifications = await Get.find<NotificationController>().checkNotification();

      if (hasNewNotifications) {
        debugPrint("🔔 New notification received!");
      }
    } catch (e) {
      debugPrint("❌ Error checking notifications: $e");
    }
  });
}

void stopNotificationChecker() {
  if (_notificationTimer != null) {
    _notificationTimer!.cancel();
    _notificationTimer = null;
    debugPrint("🛑 Notification checker stopped");
  }
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
    // await startNotificationChecker();
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
