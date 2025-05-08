// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_routes.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/core/utils/app_strings.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:business_application/data/posts/posts_models.dart';
import 'package:business_application/data/posts/topic_models.dart';
import 'package:business_application/features/community/controller/community_controller.dart';
import 'package:business_application/features/groups/controller/groups_controller.dart';
import 'package:business_application/features/groups/data/groups_topic_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class EditPostPage extends StatefulWidget {
  final Posts post;

  const EditPostPage({super.key, required this.post});

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final CommunityController controller = Get.find<CommunityController>();

  @override
  void initState() {
    super.initState();

    final isDebug = true;

    Future.microtask(() async {
      if (isDebug) {
        debugPrint("\n\n=========== EDIT POST PAGE DIAGNOSTICS ===========");
        debugPrint("EDIT POST PAGE: Initializing EditPostPage with post ID ${widget.post.id}");
      }

      // Clear the edit post data
      controller.clearEditPostData();

      // Load topics first
      if (widget.post.groupId != null) {
        if (isDebug) {
          debugPrint("EDIT POST PAGE: Loading group topics for group ID ${widget.post.groupId}");
        }
        final groupsController = Get.find<GroupsController>();
        await groupsController.fetchGroupsTopic(widget.post.groupId.toString());

        if (isDebug) {
          final topics = groupsController.groupsTopicResponse.value.result?.data ?? [];
          debugPrint("EDIT POST PAGE: Loaded ${topics.length} group topics:");
          for (var topic in topics) {
            debugPrint("  - ${topic.name} (ID: ${topic.id})");
          }
        }
      } else {
        if (isDebug) debugPrint("EDIT POST PAGE: Loading community topics");
        await controller.getTopic();

        if (isDebug) {
          final topics = controller.topics.value.result?.data ?? [];
          debugPrint("EDIT POST PAGE: Loaded ${topics.length} community topics");
        }
      }

      // Populate the edit fields with the post data
      controller.editPostController.text = Get.find<CommunityController>().cleanHtml(
        widget.post.content ?? '',
      );
      controller.editVideoController.text = widget.post.videoUrl ?? '';
      controller.editSelectedImage.value = widget.post.image ?? '';

      if (widget.post.videoUrl != null) {
        controller.selectedTabIndex.value = 1;
      }

      // Set the selected topic
      if (widget.post.topic?.name != null) {
        controller.editSelectedTopic.value = widget.post.topic!.name!;
        controller.editSelectedTopicId.value = widget.post.topic!.id?.toString() ?? '';
      }

      if (isDebug) {
        debugPrint("EDIT POST PAGE: Loaded post data:");
        debugPrint("  Content: ${controller.editPostController.text}");
        debugPrint("  Video URL: ${controller.editVideoController.text}");
        debugPrint("  Image: ${controller.editSelectedImage.value}");
        debugPrint("  Topic: ${controller.editSelectedTopic.value}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.clearEditPostData();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Post"),
          actionsPadding: EdgeInsets.symmetric(horizontal: 10),
          actions: [
            FilledButton(
              onPressed: () {
                if (controller.editSelectedTopicId.value.isEmpty) {
                  Ui.showErrorSnackBar(context, message: "Please select a topic");
                  return;
                }

                if (controller.editPostController.text.isEmpty) {
                  Ui.showErrorSnackBar(context, message: "Please enter post content");
                  return;
                }

                if (controller.editPostController.text.length < 10) {
                  Ui.showErrorSnackBar(
                    context,
                    message: "Post content must be at least 10 characters",
                  );
                  return;
                }

                controller.updatePost(
                  postId: widget.post.id.toString(),
                  content: controller.editPostController.text,
                  topicId: controller.editSelectedTopicId.value,
                  videoUrl: controller.editVideoController.text,
                  groupId: widget.post.groupId?.toString(),
                );
                if (widget.post.groupId != null) {
                  context.replace(AppRoutes.groupDetails);
                } else {
                  context.go(AppRoutes.communityFeed);
                }
              },
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
              ),
              child: const Text("Update", style: TextStyle(color: Colors.white)),
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
                      controller: controller.editPostController,
                      focusNode: controller.postFocusNode,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: AppStrings.edit,
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
                            tabs: const [Tab(text: "Image"), Tab(text: "Video")],
                          ),
                          14.hS,
                          if (controller.selectedTabIndex.value == 0) ...[
                            Obx(
                              () =>
                                  controller.editSelectedImage.value.isNotEmpty
                                      ? Stack(
                                        children: [
                                          Container(
                                            height: 200.h,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              image: DecorationImage(
                                                image:
                                                    controller.editSelectedImage.value.contains(
                                                          "http",
                                                        )
                                                        ? NetworkImage(
                                                          controller.editSelectedImage.value,
                                                        )
                                                        : FileImage(
                                                              File(
                                                                controller.editSelectedImage.value,
                                                              ),
                                                            )
                                                            as ImageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: GestureDetector(
                                              onTap: () => controller.editSelectedImage.value = '',
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade600,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(Icons.close, color: Colors.white),
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
                                    onPressed: () => controller.pickEditImage(ImageSource.camera),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFE9F0FF),
                                      fixedSize: Size(165.w, 50.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                    ),
                                    label: const Text(
                                      "Camera",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    icon: Icon(
                                      Icons.photo_camera,
                                      size: 24,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                                10.wS,
                                Flexible(
                                  child: ElevatedButton.icon(
                                    onPressed: () => controller.pickEditImage(ImageSource.gallery),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFE9F0FF),
                                      fixedSize: Size(165.w, 50.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                    ),
                                    label: const Text(
                                      "Add Photos",
                                      style: TextStyle(color: Colors.black),
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
                          ] else if (controller.selectedTabIndex.value == 1) ...[
                            TextFormField(
                              controller: controller.editVideoController,
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
                    Obx(() {
                      final topicsToShow =
                          widget.post.groupId != null
                              ? Get.find<GroupsController>().groupsTopicResponse.value.result?.data
                              : controller.topics.value.result?.data;

                      return DropdownMenu<String>(
                        hintText: "Select a topic",
                        initialSelection:
                            controller.editSelectedTopic.value.isNotEmpty
                                ? controller.editSelectedTopic.value
                                : null,
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
                        trailingIcon: const Icon(Icons.keyboard_arrow_down_sharp),
                        onSelected: (val) {
                          if (val == null) return;

                          controller.editSelectedTopic.value = val;
                          if (widget.post.groupId != null) {
                            final editSelectedTopic = Get.find<GroupsController>()
                                .groupsTopicResponse
                                .value
                                .result
                                ?.data
                                ?.firstWhere(
                                  (topic) => topic.name == val,
                                  orElse: () => GroupTopics(),
                                );
                            controller.editSelectedTopicId.value =
                                editSelectedTopic?.id?.toString() ?? '';
                          } else {
                            final selectedTopic = controller.topics.value.result?.data?.firstWhere(
                              (topic) => topic.name == val,
                              orElse: () => Topic(),
                            );
                            controller.editSelectedTopicId.value =
                                selectedTopic?.id?.toString() ?? '';
                          }
                        },
                        dropdownMenuEntries:
                            topicsToShow?.map((topic) {
                              if (widget.post.groupId != null) {
                                final groupTopic = topic as GroupTopics;
                                return DropdownMenuEntry<String>(
                                  value: groupTopic.name ?? '',
                                  label: groupTopic.name ?? '',
                                );
                              } else {
                                final communityTopic = topic as Topic;
                                return DropdownMenuEntry<String>(
                                  value: communityTopic.name ?? '',
                                  label: communityTopic.name ?? '',
                                );
                              }
                            }).toList() ??
                            [],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
