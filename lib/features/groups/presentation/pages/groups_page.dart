import 'package:business_application/core/config/app_routes.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/core/utils/app_strings.dart';
import 'package:business_application/features/groups/controller/groups_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupsPage extends GetView<GroupsController> {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.fetchGroups();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Groups',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchGroups(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.hS,
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (controller.groups.value.result?.data?.isEmpty ?? true) {
                  return Center(
                    heightFactor: 3.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.group_outlined,
                          size: 80.sp,
                          color: Colors.grey.shade400,
                        ),
                        10.hS,
                        Text(
                          AppStrings.noGroupsFound,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: controller.groups.value.result?.data?.length,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          child: Image.asset(
                            "assets/logo/icon.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        title: Text(
                          controller.groups.value.result?.data?[index].name ??
                              "",
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                        onTap: () async {
                          try {
                            controller.isLoading(true);
                            final groupId =
                                controller.groups.value.result?.data?[index].id
                                    .toString() ??
                                "";

                            // Store the groupId in the controller for use in GroupDetailsPage
                            controller.currentGroupId.value = groupId;

                            controller.fetchGroupsTopic(groupId);
                            controller.fetchGroupsDetails(groupId);
                            controller.fetchGroupPosts(groupId);

                            // Use GoRouter for navigation to match your app's routing system
                            context.push(AppRoutes.groupDetails);
                          } catch (e) {
                            debugPrint("Error navigating to group details: $e");
                          } finally {
                            controller.isLoading(false);
                          }
                        },
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
