import 'package:business_application/routes/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes/app_router.dart'; // Import the new router file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationParser: AppRouter.router.routeInformationParser,
      routerDelegate: AppRouter.router.routerDelegate,
      routeInformationProvider: AppRouter.router.routeInformationProvider,
      title: 'Business Academy',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      initialBinding: DependencyInjection(),
    );
  }
}
