// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stepup_community/core/config/app_colors.dart';
import 'package:stepup_community/core/config/app_routes.dart';
import 'package:stepup_community/core/config/app_size.dart';
import 'package:stepup_community/core/utils/ui_support.dart';
import 'package:stepup_community/data/posts/posts_models.dart';
import 'package:stepup_community/data/posts/topic_models.dart';
import 'package:stepup_community/features/community/controller/community_controller.dart';
import 'package:stepup_community/features/groups/controller/groups_controller.dart';
import 'package:stepup_community/features/groups/data/groups_topic_response_model.dart';

class EditPostPage extends StatefulWidget {
  final Posts post;

  const EditPostPage({super.key, required this.post});

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> with SingleTickerProviderStateMixin {
  final CommunityController controller = Get.find<CommunityController>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

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
      controller.editPostController.text = Get.find<CommunityController>().cleanHtml(widget.post.content ?? '');
      controller.editVideoController.text = widget.post.videoUrl ?? '';
      controller.editSelectedImage.value = widget.post.image ?? '';

      if (widget.post.videoUrl != null && widget.post.videoUrl!.isNotEmpty) {
        controller.selectedTabIndex.value = 1;
        _tabController.index = 1;
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Ui.isDarkMode(context);

    return WillPopScope(
      onWillPop: () async {
        controller.clearEditPostData();
        return true;
      },
      child: Scaffold(
        backgroundColor: dark ? const Color(0xFF0A0A0A) : const Color(0xFFF5F7FA),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: dark ? const Color(0xFF1A1A1A) : Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: dark ? Colors.white : Colors.black, size: 16.sp),
            onPressed: () {
              controller.clearEditPostData();
              context.pop();
            },
          ),
          title: Text(
            "Edit Post",
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: dark ? Colors.white : Colors.black,
            ),
          ),
          centerTitle: true,
          actions: [Container(margin: EdgeInsets.only(right: 16.w), child: _buildUpdateButton())],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Content Editor
              _buildContentEditor(dark),

              24.hS,

              // Media Section
              _buildMediaSection(dark),

              24.hS,

              // Topic Selector
              _buildTopicSelector(dark),

              100.hS, // Extra space at bottom
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: ElevatedButton(
          onPressed: _handleUpdate,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            elevation: 0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller.isLoading.value) ...[
                SizedBox(
                  width: 16.w,
                  height: 16.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                8.wS,
              ],
              Text("Update", style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentEditor(bool dark) {
    return Container(
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: dark ? Colors.black26 : Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: TextFormField(
          controller: controller.editPostController,
          focusNode: controller.postFocusNode,
          maxLines: 6,
          style: GoogleFonts.inter(fontSize: 14.sp, color: dark ? Colors.white : Colors.black, height: 1.5),
          decoration: InputDecoration(
            hintText: "Edit your content...",
            hintStyle: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 14.sp),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
        ),
      ),
    );
  }

  Widget _buildMediaSection(bool dark) {
    return Container(
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: dark ? Colors.black26 : Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: Row(
              children: [
                Icon(Icons.image_outlined, color: AppColors.primaryColor, size: 20.sp),
                8.wS,
                Text(
                  "Media",
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: dark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // Tab Bar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: dark ? const Color(0xFF2A2A2A) : const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              onTap: (index) => controller.selectedTabIndex.value = index,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(colors: [AppColors.primaryColor, const Color(0xFF003BC6)]),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey.shade500,
              labelStyle: GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w600),
              unselectedLabelStyle: GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w500),
              tabs: [Tab(text: "Image"), Tab(text: "Video")],
            ),
          ),

          16.hS,

          // Tab Content
          Obx(
            () => Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: controller.selectedTabIndex.value == 0 ? _buildImageTab(dark) : _buildVideoTab(dark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageTab(bool dark) {
    return Column(
      children: [
        Obx(
          () =>
              controller.editSelectedImage.value.isNotEmpty
                  ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 200.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  controller.editSelectedImage.value.contains("http")
                                      ? NetworkImage(controller.editSelectedImage.value)
                                      : FileImage(File(controller.editSelectedImage.value)) as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: GestureDetector(
                          onTap: () => controller.editSelectedImage.value = '',
                          child: Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), shape: BoxShape.circle),
                            child: Icon(Icons.close, color: Colors.white, size: 16.sp),
                          ),
                        ),
                      ),
                    ],
                  )
                  : const SizedBox(),
        ),

        if (controller.editSelectedImage.value.isNotEmpty) 16.hS,

        Row(
          children: [
            Expanded(
              child: _buildMediaButton(
                icon: Icons.camera_alt_outlined,
                label: "Camera",
                onTap: () => controller.pickEditImage(ImageSource.camera),
                dark: dark,
              ),
            ),
            12.wS,
            Expanded(
              child: _buildMediaButton(
                icon: Icons.photo_library_outlined,
                label: "Gallery",
                onTap: () => controller.pickEditImage(ImageSource.gallery),
                dark: dark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVideoTab(bool dark) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF2A2A2A) : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dark ? Colors.grey.shade700 : Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.video_library_outlined, color: AppColors.primaryColor, size: 18.sp),
              8.wS,
              Text(
                "Video URL",
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: dark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          12.hS,
          TextFormField(
            controller: controller.editVideoController,
            style: GoogleFonts.inter(fontSize: 14.sp, color: dark ? Colors.white : Colors.black),
            decoration: InputDecoration(
              hintText: "Paste YouTube video link here...",
              hintStyle: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13.sp),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool dark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF2A2A2A) : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: dark ? Colors.grey.shade700 : Colors.grey.shade200, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 18.sp),
            8.wS,
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: dark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicSelector(bool dark) {
    return Container(
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: dark ? Colors.black26 : Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: Row(
              children: [
                Icon(Icons.tag_outlined, color: AppColors.primaryColor, size: 20.sp),
                8.wS,
                Text(
                  "Topic",
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: dark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: dark ? Colors.grey.shade800 : Colors.grey.shade200),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Obx(() {
              final topicsToShow =
                  widget.post.groupId != null
                      ? Get.find<GroupsController>().groupsTopicResponse.value.result?.data
                      : controller.topics.value.result?.data;

              return DropdownButtonFormField<String>(
                value: controller.editSelectedTopic.value.isNotEmpty ? controller.editSelectedTopic.value : null,
                decoration: InputDecoration(
                  hintText: "Select a topic",
                  hintStyle: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 14.sp),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: dark ? Colors.grey.shade700 : Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: dark ? Colors.grey.shade700 : Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: dark ? const Color(0xFF2A2A2A) : const Color(0xFFF8F9FA),
                ),
                style: GoogleFonts.inter(fontSize: 14.sp, color: dark ? Colors.white : Colors.black),
                dropdownColor: dark ? const Color(0xFF1A1A1A) : Colors.white,
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500),
                onChanged: (val) {
                  if (val == null) return;

                  controller.editSelectedTopic.value = val;
                  if (widget.post.groupId != null) {
                    final editSelectedTopic = Get.find<GroupsController>().groupsTopicResponse.value.result?.data
                        ?.firstWhere((topic) => topic.name == val, orElse: () => GroupTopics());
                    controller.editSelectedTopicId.value = editSelectedTopic?.id?.toString() ?? '';
                  } else {
                    final selectedTopic = controller.topics.value.result?.data?.firstWhere(
                      (topic) => topic.name == val,
                      orElse: () => Topic(),
                    );
                    controller.editSelectedTopicId.value = selectedTopic?.id?.toString() ?? '';
                  }
                },
                items:
                    topicsToShow?.map((topic) {
                      if (widget.post.groupId != null) {
                        final groupTopic = topic as GroupTopics;
                        return DropdownMenuItem<String>(
                          value: groupTopic.name ?? '',
                          child: Text(
                            groupTopic.name ?? '',
                            style: GoogleFonts.inter(fontSize: 14.sp, color: dark ? Colors.white : Colors.black),
                          ),
                        );
                      } else {
                        final communityTopic = topic as Topic;
                        return DropdownMenuItem<String>(
                          value: communityTopic.name ?? '',
                          child: Text(
                            communityTopic.name ?? '',
                            style: GoogleFonts.inter(fontSize: 14.sp, color: dark ? Colors.white : Colors.black),
                          ),
                        );
                      }
                    }).toList() ??
                    [],
              );
            }),
          ),
        ],
      ),
    );
  }

  void _handleUpdate() {
    if (controller.editSelectedTopicId.value.isEmpty) {
      Ui.showErrorSnackBar(context, message: "Please select a topic");
      return;
    }

    if (controller.editPostController.text.isEmpty) {
      Ui.showErrorSnackBar(context, message: "Please enter post content");
      return;
    }

    if (controller.editPostController.text.length < 10) {
      Ui.showErrorSnackBar(context, message: "Post content must be at least 10 characters");
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
  }
}
