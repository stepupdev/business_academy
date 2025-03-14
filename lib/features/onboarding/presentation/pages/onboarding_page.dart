import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: const [
          OnboardingContent(content: 'Welcome to the app!'),
          OnboardingContent(content: 'Discover new features!'),
          OnboardingContent(content: 'Get started now!'),
        ],
      ),
      bottomSheet: TextButton(
        onPressed: () {
          context.go('/signin');
        },
        child: const Text('Get Started'),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String content;

  const OnboardingContent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(content, style: Theme.of(context).textTheme.headlineMedium));
  }
}
