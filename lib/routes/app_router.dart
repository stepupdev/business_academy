import 'package:business_application/features/auth/controller/auth_controller.dart';
import 'package:business_application/features/auth/presentation/pages/signin_page.dart';
import 'package:business_application/features/community/presentation/pages/community_page.dart';
import 'package:business_application/features/feed/presentation/pages/feed_page.dart';
import 'package:business_application/features/home/presentation/pages/home_page.dart';
import 'package:business_application/features/initial/presentation/pages/initial_screen.dart';
import 'package:business_application/features/menu/presentation/pages/menu_page.dart';
import 'package:business_application/features/notification/presentation/pages/notification_page.dart';
import 'package:business_application/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:business_application/features/onboarding/presentation/pages/splash_page.dart';
import 'package:business_application/routes/not_found_page.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/initial', builder: (context, state) => const InitialScreen()),
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingPage()),
      GoRoute(
        path: '/signin',
        builder: (context, state) {
          Get.put(AuthController());
          return const SignInPage();
        },
      ),
      GoRoute(path: '/home', builder: (context, state) => HomePage()),
      GoRoute(path: '/community', builder: (context, state) => CommunityPage()),
      GoRoute(path: '/menu', builder: (context, state) => MenuPage()),
      GoRoute(path: '/feed', builder: (context, state) => FeedPage()),
      GoRoute(path: '/notifications', builder: (context, state) => NotificationPage()),
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
  );
}
