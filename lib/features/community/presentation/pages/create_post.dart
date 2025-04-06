// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/features/community/controller/community_controller.dart';
import 'package:business_application/features/community/data/topics_model.dart';
import 'package:business_application/features/groups/controller/groups_controller.dart';
import 'package:business_application/features/groups/data/groups_topic_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends GetView<CommunityController> {
  final bool isGroupTopics;
  final String? postId; // Optional postId for editing
  final String? groupId; // Group ID for group posts

  const CreatePostPage({super.key, required this.isGroupTopics, this.postId, this.groupId});

  @override
  Widget build(BuildContext context) {
    if (postId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadPostData(postId ?? "");
        controller.selectedTopic.value = controller.communityPostsById.value.result?.topic?.name ?? '';
        controller.selectedTopicId.value = controller.communityPostsById.value.result?.topic?.id?.toString() ?? '';
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(postId == null ? "Create Post" : "Edit Post"),
        actionsPadding: EdgeInsets.symmetric(horizontal: 10),
        actions: [
          FilledButton(
            onPressed: () {
              if (postId == null || isGroupTopics) {
                controller.createNewPosts(groupId: groupId); // Pass groupId for group posts
              } else {
                controller.updatePost(
                  postId: postId ?? "",
                  content: controller.postController.text,
                  topicId: controller.selectedTopicId.value,
                  videoUrl: controller.videoLinkController.text,
                  groupId: groupId, // Pass groupId for updating group posts
                );
              }
            },
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
            ),
            child: Text(
              postId == null ? "Share" : "Update",
              style: TextStyle(color: Colors.white),
            ), // Update button text
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
                    controller: controller.postController, // Ensure the controller is bound
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: postId == null ? "Write something..." : "Edit your post...",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.borderColor, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primaryColor, width: 0.5),
                      ),
                    ),
                    onEditingComplete: () {
                      controller.postController.text = controller.postController.text.trim();
                    },
                    onTapOutside: (event) => FocusScope.of(context).unfocus(), // Dismiss keyboard on tap outside
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
                                controller.selectedImage.value.isNotEmpty
                                    ? Stack(
                                      children: [
                                        Container(
                                          height: 200.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            image:
                                                postId == null || !controller.selectedImage.value.contains("http")
                                                    ? DecorationImage(
                                                      image: FileImage(File(controller.selectedImage.value)),
                                                      fit: BoxFit.cover,
                                                    )
                                                    : DecorationImage(
                                                      image: NetworkImage(controller.selectedImage.value),
                                                      fit: BoxFit.cover,
                                                    ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: () => controller.selectedImage.value = '',
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
                                    fixedSize: Size(165.w, 50.h),
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
                                    fixedSize: Size(165.w, 50.h),
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
                    initialSelection: controller.selectedTopic.value,
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
                      if (isGroupTopics) {
                        final selectedTopic = Get.find<GroupsController>().groupsTopicResponse.value.result?.data
                            ?.firstWhere((topic) => topic.name == val, orElse: () => GroupTopics());
                        controller.selectedTopicId.value = selectedTopic?.id?.toString() ?? '';
                      } else {
                        final selectedTopic = controller.topics.value.result?.data?.firstWhere(
                          (topic) => topic.name == val,
                          orElse: () => Topic(),
                        );
                        controller.selectedTopicId.value = selectedTopic?.id?.toString() ?? '';
                      }
                    },
                    dropdownMenuEntries:
                        (isGroupTopics
                                ? Get.find<GroupsController>().groupsTopicResponse.value.result?.data
                                : controller.topics.value.result?.data)
                            ?.map((topic) {
                              if (isGroupTopics) {
                                final groupTopic = topic as GroupTopics;
                                return DropdownMenuEntry<Object>(
                                  value: groupTopic.name ?? '',
                                  label: groupTopic.name ?? '',
                                );
                              } else {
                                final communityTopic = topic as Topic;
                                return DropdownMenuEntry<Object>(
                                  value: communityTopic.name ?? '',
                                  label: communityTopic.name ?? '',
                                );
                              }
                            })
                            .toList() ??
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
