import 'package:business_application/core/config/app_routes.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/features/groups/controller/groups_controller.dart';
import 'package:business_application/features/groups/presentation/pages/groups_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupsPage extends GetView<GroupsController> {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups', style: GoogleFonts.plusJakartaSans(fontSize: 18.sp, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text("My Groups", style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700)),
              ),
              20.hS,
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: controller.groups.value.result?.data?.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        child: Image.asset("assets/logo/icon.png", fit: BoxFit.contain),
                      ),
                      title: Text(
                        controller.groups.value.result?.data?[index].name ?? "",
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16.sp),
                      ),
                      onTap: () {
                        controller.fetchGroupsTopic(controller.groups.value.result?.data?[index].id.toString() ?? "");
                        controller.fetchGroupsDetails(controller.groups.value.result?.data?[index].id.toString() ?? "");
                        context.push(AppRoutes.groupDetails);
                      },
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
