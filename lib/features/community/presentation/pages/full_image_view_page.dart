import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullImageViewPage extends StatelessWidget {
  final String imageUrl;
  const FullImageViewPage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PhotoView(
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2,
        imageProvider: NetworkImage(imageUrl),
      ),
    );
  }
}
