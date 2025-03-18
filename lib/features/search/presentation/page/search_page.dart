import 'package:business_application/core/config/app_colors.dart';
import 'package:business_application/core/config/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<String> _searchHistory = ['Flutter', 'Dart', 'Firebase'];
  final List<String> _topics = ['All', 'Tech', 'Business', 'Health'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Search Text Field
              Row(
                children: [
                  IconButton(icon: HeroIcon(HeroIcons.arrowLeft), onPressed: () => Navigator.of(context).pop()),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onTapOutside: (event) => FocusScope.of(context).unfocus(),
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
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
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => SizedBox(width: 5.w),
                    itemCount: _topics.length,
                    itemBuilder: (context, index) {
                      final topic = _topics[index];
                      return IntrinsicHeight(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[200] ?? Colors.grey),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            children: [
                              Text(
                                topic,
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Divider(thickness: 0.5, color: Colors.grey.shade300),
              10.hS,

              Expanded(
                child:
                    _searchQuery.isEmpty
                        ? ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(height: 10.h),
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                          itemCount: _searchHistory.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                _searchController.text = _searchHistory[index];
                                setState(() {
                                  _searchQuery = _searchHistory[index];
                                });
                              },
                              child: Row(children: [HeroIcon(HeroIcons.magnifyingGlass), Text(_searchHistory[index])]),
                            );
                          },
                        )
                        : Column(
                          children: [
                            Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'Search Results: ',
                                    style: GoogleFonts.plusJakartaSans(color: Colors.grey),
                                    children: [
                                      TextSpan(
                                        text: '"$_searchQuery"',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Text("150 results", style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
                              ],
                            ),
                            15.hS,
                            Expanded(
                              child: ListView.builder(
                                itemCount: 10, // Replace with actual search results count
                                itemBuilder: (context, index) {
                                  return ListTile(title: Text('Result $index for "$_searchQuery"'));
                                },
                              ),
                            ),
                          ],
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
