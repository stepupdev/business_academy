import 'package:business_application/core/config/app_routes.dart';
import 'package:business_application/features/auth/presentation/pages/signin_page.dart';
import 'package:business_application/features/community/presentation/pages/create_post.dart';
import 'package:business_application/features/community/presentation/pages/post_details_page.dart';
import 'package:business_application/features/home/presentation/pages/home_page.dart';
import 'package:business_application/features/initial/presentation/pages/initial_screen.dart';
import 'package:business_application/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.initial,
    routes: [
      GoRoute(
        path: AppRoutes.initial,
        builder: (context, state) => const InitialScreen(),
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: const InitialScreen()),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInPage(),
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: const SignInPage()),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: const HomePage()),
      ),
      GoRoute(
        path: AppRoutes.createPost,
        builder: (context, state) => CreatePostPage(),
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: CreatePostPage()),
      ),
      GoRoute(
        path: AppRoutes.postDetails,
        builder: (context, state) => PostDetailsPage(postIndex: state.extra as int),
        pageBuilder:
            (context, state) => MaterialPage(key: state.pageKey, child: PostDetailsPage(postIndex: state.extra as int)),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: const OnboardingPage()),
      ),
    ],
  );
}
