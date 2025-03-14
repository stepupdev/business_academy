import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatelessWidget {
  final GoogleSignInAccount? user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user?.email ?? 'Home')),
      body: ListView(children: [PostCard(user: user, content: 'This is a sample post.')]),
    );
  }
}

class PostCard extends StatelessWidget {
  final GoogleSignInAccount? user;
  final String content;

  const PostCard({super.key, required this.user, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(title: Text(user?.email ?? 'Anonymous'), subtitle: Text(content)),
          ButtonBar(
            children: [
              TextButton(onPressed: () {}, child: const Text('Like')),
              TextButton(onPressed: () {}, child: const Text('Comment')),
            ],
          ),
        ],
      ),
    );
  }
}
