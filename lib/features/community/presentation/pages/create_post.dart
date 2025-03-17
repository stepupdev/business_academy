import 'dart:io';
import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends StatelessWidget {
  final List<String> categories = ["Category 1", "Category 2", "Category 3"];
  final RxString selectedCategory = "Category 1".obs;
  final TextEditingController postController = TextEditingController();
  final Rx<File?> selectedImage = Rx<File?>(null);

  CreatePostPage({super.key});

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Create Post"),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Handle post submission
              final postContent = postController.text;
              final category = selectedCategory.value;
              // Save the post content and category
              print("Category: $category, Post: $postContent");
            },
            child: Text("Post", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Obx(
            //   () => DropdownButton<String>(
            //     value: selectedCategory.value,
            //     onChanged: (newValue) {
            //       if (newValue != null) {
            //         selectedCategory.value = newValue;
            //       }
            //     },
            //     items:
            //         categories.map<DropdownMenuItem<String>>((String value) {
            //           return DropdownMenuItem<String>(value: value, child: Text(value));
            //         }).toList(),
            //   ),
            // ),
            // SizedBox(height: 20),
            TextField(
              controller: postController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Write something...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                ),
              ),
            ),
            14.hS,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE9F0FF),
                    fixedSize: Size(165.w, 48.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  label: Text("Camera"),
                  icon: Icon(Icons.camera),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE9F0FF),
                    fixedSize: Size(165.w, 48.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  label: Text("Add Photos"),
                  icon: Icon(Icons.image),
                ),
              ],
            ),
            14.hS,
            Obx(
              () =>
                  selectedImage.value != null
                      ? Stack(
                        children: [
                          Image.file(selectedImage.value!),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => selectedImage.value = null,
                              child: Container(
                                decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                child: Icon(Icons.close, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )
                      : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
