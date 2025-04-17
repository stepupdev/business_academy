// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/core/utils/app_strings.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:business_application/data/posts/topic_models.dart';
import 'package:business_application/features/community/controller/community_controller.dart';
import 'package:business_application/features/groups/controller/groups_controller.dart';
import 'package:business_application/features/groups/data/groups_topic_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/image_picker_widget.dart';

class CreatePostPage extends StatefulWidget {
  final bool isGroupTopics;
  final String? groupId;

  const CreatePostPage({super.key, required this.isGroupTopics, this.groupId});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final controller = Get.find<CommunityController>();
      controller.clearCreatePostData();
      controller.selectedTopic.value = "";
      controller.selectedTopicId.value = "";

      // Load topics
      if (widget.isGroupTopics && widget.groupId != null) {
        final groupsController = Get.find<GroupsController>();
        groupsController.fetchGroupsTopic(widget.groupId!);
      } else {
        controller.getTopic();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CommunityController>();

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   if (isDebug) {
    //     debugPrint("\n\n=========== CREATE POST PAGE DIAGNOSTICS ===========");
    //     debugPrint("isGroupTopics = ${widget.isGroupTopics} (This controls which topics are shown)");
    //     debugPrint("groupId = ${widget.groupId} (This identifies which group's topics to load)");
    //   }

    //   controller.clearCreatePostData();
    //   controller.selectedTopic.value = "";
    //   controller.selectedTopicId.value = "";

    //   // Load topics
    //   if (widget.isGroupTopics && widget.groupId != null) {
    //     if (isDebug) debugPrint("CREATE POST PAGE: Loading group topics for group ID ${widget.groupId}");
    //     final groupsController = Get.find<GroupsController>();
    //     await groupsController.fetchGroupsTopic(widget.groupId!);

    //     if (isDebug) {
    //       final topics = groupsController.groupsTopicResponse.value.result?.data ?? [];
    //       debugPrint("CREATE POST PAGE: Loaded ${topics.length} group topics:");
    //       topics.forEach((topic) {
    //         debugPrint("  - ${topic.name} (ID: ${topic.id})");
    //       });
    //     }
    //   } else {
    //     if (isDebug) debugPrint("CREATE POST PAGE: Loading community topics");
    //     await controller.getTopic();

    //     if (isDebug) {
    //       final topics = controller.topics.value.result?.data ?? [];
    //       debugPrint("CREATE POST PAGE: Loaded ${topics.length} community topics");
    //     }
    //   }
    // });

    return WillPopScope(
      onWillPop: () async {
        controller.clearCreatePostData();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create Post"),
          actionsPadding: EdgeInsets.symmetric(horizontal: 10),
          actions: [
            FilledButton(
              onPressed: () {
                if (controller.createPostController.value.text.isEmpty) {
                  Ui.showErrorSnackBar(context, message: AppStrings.createPostPrompt);
                  return;
                }
                if (controller.createPostController.value.text.length < 10) {
                  Ui.showErrorSnackBar(context, message: "Post must be at least 10 characters");
                  return;
                }
                if (controller.selectedTopicId.value.isEmpty) {
                  Ui.showErrorSnackBar(context, message: "Please select a topic");
                  return;
                }

                controller.createNewPosts(groupId: widget.isGroupTopics ? widget.groupId : null);
                context.pop();
              },
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
              ),
              child: const Text("Share", style: TextStyle(color: Colors.white)),
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
                      controller: controller.createPostController,
                      focusNode: controller.postFocusNode,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: AppStrings.createPostPrompt,
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
                                  controller.selectedImage.value.isNotEmpty
                                      ? Stack(
                                        children: [
                                          Container(
                                            height: 200.h,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              image: DecorationImage(
                                                image: FileImage(File(controller.selectedImage.value)),
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
                              spacing: 10.w,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: ImagePickerWidget(
                                    text: 'Camera',
                                    icon: Icons.photo_camera,
                                    onTap: () => controller.pickImage(ImageSource.camera),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: ImagePickerWidget(
                                    icon: Icons.photo,
                                    text: 'Gallery',
                                    onTap: () => controller.pickImage(ImageSource.gallery),
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
                    Obx(() {
                      final isDebug = true;
                      final topicsToShow =
                          widget.isGroupTopics
                              ? Get.find<GroupsController>().groupsTopicResponse.value.result?.data
                              : controller.topics.value.result?.data;

                      final currentSelection = controller.selectedTopic.value;

                      if (isDebug) {
                        debugPrint("=========== DROPDOWN REBUILD ===========");
                        debugPrint("isGroupTopics = ${widget.isGroupTopics}");
                        debugPrint("Current selection = '$currentSelection' (ID: ${controller.selectedTopicId.value})");
                        debugPrint("Available topics: ${topicsToShow?.length ?? 0}");
                        topicsToShow?.forEach((topic) {
                          final name = widget.isGroupTopics ? (topic as GroupTopics).name : (topic as Topic).name;
                          debugPrint("  - $name");
                        });
                      }

                      return DropdownMenu<String>(
                        hintText: "Select a topic",
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

                          if (isDebug) debugPrint("CREATE POST PAGE: Topic selected: $val");

                          controller.selectedTopic.value = val;
                          if (widget.isGroupTopics) {
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

                          if (isDebug) {
                            debugPrint("CREATE POST PAGE: Set topic ID to: ${controller.selectedTopicId.value}");
                          }
                        },
                        dropdownMenuEntries:
                            topicsToShow?.map((topic) {
                              if (widget.isGroupTopics) {
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
