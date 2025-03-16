import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Text('Not Found', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
      ),
    );
  }
}
