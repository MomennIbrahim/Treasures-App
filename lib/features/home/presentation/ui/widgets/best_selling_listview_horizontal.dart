import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/home/data/demo/demo_best_selling_data.dart';
import 'package:konoz/features/home/presentation/ui/widgets/best_selling_item.dart';

class BestSellingListviewHorizontal extends StatelessWidget {
  final List<ProductItemModel> products;
  final bool isLoading;

  const BestSellingListviewHorizontal({
    super.key,
    required this.products,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final displayProducts = isLoading
        ? DemoBestSellingData.demo.products
        : products;

    return SizedBox(
      height: 240.h,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: paddingHorizontal(16),
        scrollDirection: Axis.horizontal,
        itemCount: displayProducts.length,
        separatorBuilder: (context, index) => 10.horizontalSpace,
        itemBuilder: (context, index) {
          return BestSellingItem(
            product: displayProducts[index],
            isLoading: isLoading,
          );
        },
      ),
    );
  }
}
