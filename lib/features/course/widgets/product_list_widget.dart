import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:stepup_community/core/utils/theme/colors.dart';

class ProductListWidget extends StatelessWidget {
  const ProductListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      itemCount: 10,
      separatorBuilder: (_, __) => Gap(12.h),
      itemBuilder:
          (context, index) => const ProductCard(
            title: 'Meril Baby Powder 100gm',
            price: 20.0,
            imageUrl:
                'https://plus.unsplash.com/premium_photo-1726768937392-786669364bd5?q=80&w=2946&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
          ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String title;
  final double price;
  final String imageUrl;

  const ProductCard({super.key, required this.title, required this.price, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildProductImage(context),
        Gap(16.w),
        _buildProductDetails(context),
        _buildAddButton(context),
      ],
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return SizedBox(
      width: 97.w,
      height: 97.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: TColors.borderPrimary),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Image.network(imageUrl),
        ),
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.w500,
              color: TColors.textPrimary,
            ),
          ),
          Gap(10.h),
          Text(
            '\$${price.toStringAsFixed(2)}',
            style:Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: TColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Align(
        alignment: Alignment.centerRight,
        child: FloatingActionButton.small(
          backgroundColor: TColors.primary.withValues(alpha: 0.2),
          elevation: 0,
          shape: const CircleBorder(),
          onPressed: () {},
          child: Icon(Icons.add, color: TColors.primary),
        ),
      ),
    );
  }
}
