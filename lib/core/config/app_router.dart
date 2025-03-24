import 'package:business_application/core/config/app_routes.dart';
import 'package:business_application/features/auth/presentation/pages/signin_page.dart';
import 'package:business_application/features/community/presentation/pages/create_post.dart';
import 'package:business_application/features/community/presentation/pages/post_details_page.dart';
import 'package:business_application/features/groups/presentation/pages/groups_details_page.dart';
import 'package:business_application/features/home/presentation/pages/home_page.dart';
import 'package:business_application/features/my_posts/presentation/page/my_posts_page.dart';
import 'package:business_application/features/notification/presentation/pages/notification_page.dart';
import 'package:business_application/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:business_application/features/onboarding/presentation/pages/splash_page.dart';
import 'package:business_application/features/save_posts/presentation/pages/save_posts.dart';
import 'package:business_application/features/search/presentation/page/search_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: const SplashPage()),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: const SignInPage()),
      ),
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: const HomePage()),
      ),
      GoRoute(
        path: AppRoutes.createPost,
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: CreatePostPage()),
      ),
      GoRoute(
        path: AppRoutes.postDetails,
        pageBuilder: (context, state) {
          final String? postId = state.queryParams['postId'];
          return MaterialPage(key: state.pageKey, child: PostDetailsPage(postId: postId ?? ''));
        },
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: const OnboardingPage()),
      ),
      GoRoute(
        path: AppRoutes.notification,
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: NotificationPage()),
      ),
      GoRoute(
        path: AppRoutes.savedPosts,
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: SavePostsPage()),
      ),
      GoRoute(
        path: AppRoutes.search,
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: SearchPage()),
      ),
      GoRoute(
        path: AppRoutes.groupDetails,
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: GroupDetailsPage()),
      ),
      GoRoute(
        path: AppRoutes.myPosts,
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: MyPostsPage()),
      ),
    ],
  );
}
