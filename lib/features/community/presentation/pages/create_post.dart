import 'dart:io';
import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends StatelessWidget {
  final List<String> topics = ["Topics 1", "Topics 2", "Topics 3"];
  final RxString selectedTopic = "Topics 1".obs;
  final TextEditingController postController = TextEditingController();
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxInt selectedTabIndex = 0.obs; // 0 for Image, 1 for Video
  final TextEditingController videoLinkController = TextEditingController();

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
    final dark = Ui.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post"),
        actionsPadding: EdgeInsets.symmetric(horizontal: 10),
        actions: [
          FilledButton(
            onPressed: () {
              // Handle post submission
              final postContent = postController.text;
              final category = selectedTopic.value;
              // Save the post content and category
              print("Category: $category, Post: $postContent");
            },
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
            ),
            child: Text("Share", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: postController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Write something...",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.borderColor, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primaryColor, width: 0.5),
                      ),
                    ),
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  ),
                  20.hS,
                  Obx(
                    () => Column(
                      children: [
                        TabBar(
                          onTap: (index) => selectedTabIndex.value = index,
                          indicatorColor: AppColors.primaryColor,
                          labelColor: AppColors.primaryColor,
                          unselectedLabelColor: Colors.grey,
                          tabs: [Tab(text: "Image"), Tab(text: "Video")],
                        ),
                        14.hS,
                        if (selectedTabIndex.value == 0) ...[
                          Obx(
                            () =>
                                selectedImage.value != null
                                    ? Stack(
                                      children: [
                                        Container(
                                          height: 200.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            image: DecorationImage(
                                              image: FileImage(selectedImage.value!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: () => selectedImage.value = null,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade600,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(Icons.close, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                    : Container(),
                          ),
                          14.hS,
                          Row(
                            children: [
                              Flexible(
                                child: ElevatedButton.icon(
                                  onPressed: () => _pickImage(ImageSource.camera),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFE9F0FF),
                                    fixedSize: Size(165.w, 48.h),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                                  ),
                                  label: Text("Camera", style: TextStyle(color: dark ? Colors.black : Colors.white)),
                                  icon: Icon(Icons.photo_camera, size: 24, color: AppColors.primaryColor),
                                ),
                              ),
                              10.wS,
                              Flexible(
                                child: ElevatedButton.icon(
                                  onPressed: () => _pickImage(ImageSource.gallery),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFE9F0FF),
                                    fixedSize: Size(165.w, 48.h),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                                  ),
                                  label: Text(
                                    "Add Photos",
                                    style: TextStyle(color: dark ? Colors.black : Colors.white),
                                  ),
                                  icon: Icon(
                                    Icons.photo_size_select_actual_rounded,
                                    size: 24,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ] else if (selectedTabIndex.value == 1) ...[
                          TextFormField(
                            controller: videoLinkController,
                            decoration: InputDecoration(
                              hintText: "Enter video link...",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppColors.borderColor, width: 0.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppColors.primaryColor, width: 0.5),
                              ),
                            ),
                            onTapOutside: (event) => FocusScope.of(context).unfocus(),
                          ),
                        ],
                      ],
                    ),
                  ),
                  20.hS,
                  DropdownMenu<String>(
                    initialSelection: topics.first,
                    inputDecorationTheme: InputDecorationTheme(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.borderColor),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.borderColor),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    requestFocusOnTap: true,
                    enableFilter: true,
                    trailingIcon: Icon(Icons.keyboard_arrow_down_sharp),
                    onSelected: (val) {
                      val = topics.first;
                    },
                    dropdownMenuEntries:
                        topics.map((grid) {
                          return DropdownMenuEntry<String>(value: grid, label: grid);
                        }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
