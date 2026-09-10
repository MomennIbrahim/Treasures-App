import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/home/data/demo/demo_currently_trending_model.dart';
import 'package:konoz/features/home/presentation/ui/widgets/currently_trending_item.dart';

class CurrentlyTrendingListviewHorizontal extends StatelessWidget {
  final List<ProductItemModel> products;
  final bool isLoading;

  const CurrentlyTrendingListviewHorizontal({
    super.key,
    required this.products,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final displayProducts = isLoading
        ? DemoCurrentlyTrendingData.demo.products
        : products;

    return SizedBox(
      height: 220.h,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: paddingHorizontal(16),
        scrollDirection: Axis.horizontal,
        itemCount: displayProducts.length,
        separatorBuilder: (context, index) => 8.horizontalSpace,
        itemBuilder: (context, index) {
          return CurrentlyTrendingItem(
            product: displayProducts[index],
            isLoading: isLoading,
          );
        },
      ),
    );
  }
}
