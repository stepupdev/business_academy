import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:business_application/core/utils/app_strings.dart';
import 'package:business_application/core/utils/ui_support.dart';
import 'package:business_application/features/community/controller/community_controller.dart';
import 'package:business_application/features/search/controller/search_controller.dart';
import 'package:business_application/features/search/presentation/widgets/search_post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

class SearchPage extends GetView<SearchedController> {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Ui.isDarkMode(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: HeroIcon(HeroIcons.arrowLeft),
                    onPressed: () {
                      controller.search.value.result?.data?.clear();
                      controller.searchKeyword.value = '';
                      controller.searchTextController.value.clear();
                      Navigator.of(context).pop();
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        // onTapOutside: (event) => FocusScope.of(context).unfocus(),
                        onEditingComplete: () {
                          controller.searchKeyword.value = controller.searchTextController.value.text;
                          if (controller.searchKeyword.value.isNotEmpty) {
                            if (!controller.searchHistory.contains(controller.searchKeyword.value)) {
                              if (controller.searchHistory.length >= 4) {
                                controller.searchHistory.removeAt(0);
                              }
                              controller.searchHistory.add(controller.searchKeyword.value);
                            }
                            controller.searching(controller.searchKeyword.value);
                          }
                          controller.searchTextController.value.text =
                              controller.searchKeyword.value; // Restore the keyword
                        },
                        controller: controller.searchTextController.value,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          prefixIcon: HeroIcon(HeroIcons.magnifyingGlass, color: AppColors.primaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(color: AppColors.borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(color: AppColors.borderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(color: AppColors.borderColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              15.hS,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  height: 25.h,
                  child: Obx(() {
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) => SizedBox(width: 5.w),
                      itemCount: controller.topics.value.result?.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final topic = controller.topics.value.result?.data?[index];
                        return InkWell(
                          onTap: () {
                            controller.searching(controller.searchKeyword.value, topicId: topic?.id.toString());
                          },
                          child: IntrinsicHeight(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              decoration: BoxDecoration(
                                color: dark ? AppColors.dark : Colors.white,
                                border: Border.all(color: Colors.grey[200] ?? Colors.grey),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    topic?.name ?? "",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: dark ? AppColors.light : Colors.black,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      height: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
              Divider(thickness: 0.5, color: Colors.grey.shade300),
              10.hS,
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (controller.search.value.result?.data?.isEmpty ?? true) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 80.sp, color: Colors.grey.shade400),
                          10.hS,
                          Text(
                            AppStrings.noResultsFound,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          5.hS,
                          Text(
                            "Try searching with different keywords.",
                            style: GoogleFonts.plusJakartaSans(fontSize: 14.sp, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                text: AppStrings.searchResult,
                                style: GoogleFonts.plusJakartaSans(color: Colors.grey),
                                children: [
                                  TextSpan(
                                    text: '"${controller.searchKeyword.value}"',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "${controller.search.value.result?.data?.length ?? 0} results",
                              style: GoogleFonts.plusJakartaSans(color: Colors.grey),
                            ),
                          ],
                        ),
                        15.hS,
                        Expanded(
                          child: ListView.separated(
                            separatorBuilder: (_, __) => Container(height: 2.h, color: AppColors.grey),
                            itemCount: controller.search.value.result?.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              final result = controller.search.value.result?.data?[index];
                              return SearchPostCard(
                                dp: result?.user?.avatar ?? "",
                                name: result?.user?.name ?? "",
                                time: result?.createdAt ?? DateTime.now(),
                                topic: result?.topic?.name ?? "",
                                rank: result?.user?.rank?.name ?? "",
                                onTap: () {
                                  Get.find<CommunityController>().getCommunityPostsById(result?.id.toString() ?? "");
                                  Get.find<CommunityController>().getComments(result?.id.toString() ?? "");
                                  Get.find<CommunityController>().selectedPostId.value = result?.id ?? 0;
                                  GoRouter.of(context).push('/post-details/${result?.id}');
                                },
                                postImage: result?.image ?? "",
                                commentCount: result?.commentsCount.toString() ?? "",
                                videoUrl: result?.videoUrl ?? "",
                                caption: result?.content ?? AppStrings.noPostsAvailable,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
