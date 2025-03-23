// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:business_application/features/community/data/topics_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/features/community/controller/community_controller.dart';

class CreatePostPage extends GetView<CommunityController> {
  CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post"),
        actionsPadding: EdgeInsets.symmetric(horizontal: 10),
        actions: [
          FilledButton(
            onPressed: () {
              controller.createNewPosts();
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
                    controller: controller.postController,
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
                          onTap: (index) => controller.selectedTabIndex.value = index,
                          indicatorColor: AppColors.primaryColor,
                          labelColor: AppColors.primaryColor,
                          unselectedLabelColor: Colors.grey,
                          tabs: [Tab(text: "Image"), Tab(text: "Video")],
                        ),
                        14.hS,
                        if (controller.selectedTabIndex.value == 0) ...[
                          Obx(
                            () =>
                                controller.selectedImage.value != null
                                    ? Stack(
                                      children: [
                                        Container(
                                          height: 200.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            image: DecorationImage(
                                              image: FileImage(controller.selectedImage.value!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: () => controller.selectedImage.value = null,
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
                                  onPressed: () => controller.pickImage(ImageSource.camera),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFE9F0FF),
                                    fixedSize: Size(165.w, 48.h),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                                  ),
                                  label: Text("Camera", style: TextStyle(color: Colors.black)),
                                  icon: Icon(Icons.photo_camera, size: 24, color: AppColors.primaryColor),
                                ),
                              ),
                              10.wS,
                              Flexible(
                                child: ElevatedButton.icon(
                                  onPressed: () => controller.pickImage(ImageSource.gallery),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFE9F0FF),
                                    fixedSize: Size(165.w, 48.h),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                                  ),
                                  label: Text("Add Photos", style: TextStyle(color: Colors.black)),
                                  icon: Icon(
                                    Icons.photo_size_select_actual_rounded,
                                    size: 24,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ] else if (controller.selectedTabIndex.value == 1) ...[
                          TextFormField(
                            controller: controller.videoLinkController,
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
                  DropdownMenu(
                    hintText: "Select a topic",
                    initialSelection: controller.selectedTopicValue?.result?.data?.first.name ?? '',
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
                      controller.selectedTopic.value = val as String;
                      final selectedTopic = controller.topics.value.result?.data?.firstWhere(
                        (topic) => topic.name == val,
                        orElse: () => Topic(),
                      );
                      controller.selectedTopicId.value = selectedTopic?.id?.toString() ?? '';
                    },
                    dropdownMenuEntries:
                        controller.topics.value.result?.data!.map((topic) {
                          return DropdownMenuEntry<Object>(value: topic.name ?? '', label: topic.name ?? '');
                        }).toList() ??
                        [],
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
