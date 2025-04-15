import 'package:business_application/core/config/app_routes.dart';
import 'package:business_application/features/announcements/presentation/page/announcements_page.dart';
import 'package:business_application/features/auth/presentation/pages/signin_page.dart';
import 'package:business_application/features/community/data/community_posts_model.dart';
import 'package:business_application/features/community/presentation/pages/community_feed_page.dart';
import 'package:business_application/features/community/presentation/pages/create_post.dart';
import 'package:business_application/features/community/presentation/pages/post_details_page.dart';
import 'package:business_application/features/community/presentation/pages/edit_post.dart';
import 'package:business_application/features/groups/presentation/pages/groups_details_page.dart';
import 'package:business_application/features/groups/presentation/pages/groups_page.dart';
import 'package:business_application/features/home/presentation/pages/home_page.dart';
import 'package:business_application/features/menu/presentation/pages/menu_page.dart';
import 'package:business_application/features/my_posts/presentation/page/my_posts_page.dart';
import 'package:business_application/features/notification/presentation/pages/notification_page.dart';
import 'package:business_application/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:business_application/features/onboarding/presentation/pages/splash_page.dart';
import 'package:business_application/features/save_posts/presentation/pages/save_posts.dart';
import 'package:business_application/features/search/presentation/page/search_page.dart';
import 'package:business_application/features/no_internet/presentation/pages/no_internet_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

  // Define route paths for bottom navigation tabs
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true, // Enable logging for debug
    routes: [
      // Non-shell routes
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: const SplashPage()),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: const SignInPage()),
      ),

      // Shell route for bottom navigation with ALL tab routes
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return HomePage(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.communityFeed,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const CommunityFeedScreen(key: PageStorageKey('communityFeed')),
                ),
          ),
          GoRoute(
            path: AppRoutes.groupsTab,
            pageBuilder:
                (context, state) =>
                    NoTransitionPage(key: state.pageKey, child: const GroupsPage(key: PageStorageKey('groups'))),
          ),
          GoRoute(
            path: AppRoutes.announcementsTab,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const AnnouncementsPage(key: PageStorageKey('announcements')),
                ),
          ),
          GoRoute(
            path: AppRoutes.menuTab,
            pageBuilder:
                (context, state) =>
                    NoTransitionPage(key: state.pageKey, child: const MenuPage(key: PageStorageKey('menu'))),
          ),
        ],
      ),

      // Routes that should appear OUTSIDE the bottom navigation
      GoRoute(
        path: AppRoutes.createPost,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final bool isGroup = extra['isGroupTopics'] as bool? ?? false;
          final String? groupId = extra['groupId'] as String?;
          return MaterialPage(key: state.pageKey, child: CreatePostPage(isGroupTopics: isGroup, groupId: groupId));
        },
        parentNavigatorKey: _rootNavigatorKey, // Important! This makes it show above the shell
      ),
      GoRoute(
        path: AppRoutes.postDetails,
        pageBuilder: (context, state) {
          final Map<String, dynamic> extra = state.extra as Map<String, dynamic>? ?? {};
          final bool isGroupPost = extra['isGroupPost'] as bool? ?? false;
          final String? postId = state.params['postId'];
          final String? groupId = extra['groupId'] as String?;
          final bool fromSearchPage = extra['fromSearchPage'] as bool? ?? false;
          var post = extra['post'] as Posts?;
          debugPrint(
            "ROUTER: Creating PostDetailsPage with postId: $postId, isGroupPost: $isGroupPost, groupId: $groupId",
          );
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: PostDetailsPage(
              postId: postId!,
              isGroupPost: isGroupPost,
              groupId: groupId,
              post: post,
              fromSearchPage: fromSearchPage,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
        parentNavigatorKey: _rootNavigatorKey, // Important! This makes it show above the shell
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: const OnboardingPage()),
        parentNavigatorKey: _rootNavigatorKey,
      ),
      GoRoute(
        path: AppRoutes.notification,
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: NotificationPage()),
        parentNavigatorKey: _rootNavigatorKey,
      ),
      GoRoute(
        path: AppRoutes.savedPosts,
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: SavePostsPage()),
        parentNavigatorKey: _rootNavigatorKey,
      ),
      GoRoute(
        path: AppRoutes.search,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final String? groupId = extra['groupId'] as String?;
          final bool isGroupTopics = extra['isGroup'] as bool? ?? false;
          debugPrint("ROUTER: Creating SearchPage with groupId: $groupId, isGroupTopics: $isGroupTopics");
          return MaterialPage(key: state.pageKey, child: SearchPage(isGroup: isGroupTopics, groupId: groupId));
        },
        parentNavigatorKey: _rootNavigatorKey,
      ),
      GoRoute(
        path: AppRoutes.groupDetails,
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: GroupDetailsPage()),
        parentNavigatorKey: _rootNavigatorKey,
      ),
      GoRoute(
        path: AppRoutes.myPosts,
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: MyPostsPage()),
        parentNavigatorKey: _rootNavigatorKey,
      ),
      GoRoute(
        path: AppRoutes.editPost,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final bool isGroup = extra['isGroupTopics'] as bool? ?? false;
          final String postId = extra['postId'] as String;
          final String? groupId = extra['groupId'] as String?;
          return MaterialPage(
            key: state.pageKey,
            child: EditPostPage(isGroupTopics: isGroup, postId: postId, groupId: groupId),
          );
        },
        parentNavigatorKey: _rootNavigatorKey,
      ),
      GoRoute(
        path: AppRoutes.noInternet,
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: NoInternetPage()),
      ),
    ],
  );
}
