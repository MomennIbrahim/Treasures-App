import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/favorites/presentation/ui/widgets/favorite_item.dart';
 
class FavoritesGridview extends StatelessWidget {
  final List<ProductItemModel> products;
  final bool isLoading;

  const FavoritesGridview({
    super.key,
    required this.products,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final displayProducts = isLoading
        ? []
        : products;

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: paddingHorizontal(16),
      itemCount: displayProducts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 16.w,
        mainAxisExtent: 250.h,
      ),
      itemBuilder: (context, index) {
        return FavoriteItem(
          product: displayProducts[index],
          isLoading: isLoading,
        );
      },
    );
  }
}
