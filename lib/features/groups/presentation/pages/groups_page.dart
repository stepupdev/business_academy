import 'package:business_application/core/config/app_routes.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/features/groups/presentation/pages/groups_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupsPage extends StatelessWidget {
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
              ListView.builder(
                itemCount: 5, // Replace with dynamic group count
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(radius: 25, child: Image.asset("assets/logo/icon.png", fit: BoxFit.contain)),
                    title: Text(
                      'Group ${index + 1}', // Replace with group name
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Description of Group ${index + 1}', // Replace with group description
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      context.push(AppRoutes.groupDetails);
                    },
                  );
                },
              ),
              const Divider(),
              20.hS,
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Text("Suggested Groups for you", style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700)),
              ),
              20.hS,
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 10, // Replace with dynamic group count
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(radius: 25, child: Image.asset("assets/logo/icon.png", fit: BoxFit.contain)),
                    title: Text(
                      'Group ${index + 1}', // Replace with group name
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Description of Group ${index + 1}', // Replace with group description
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFAC8EFF), Color(0xFF6027FF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const GroupDetailsPage()));
                        },
                        borderRadius: BorderRadius.circular(20.0), // Ensure ripple effect follows shape
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: const Text(
                            'Join', // Change dynamically to 'Leave' if already joined
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
