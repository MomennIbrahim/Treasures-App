import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';

class CurrentlyTrendingItem extends StatelessWidget {
  final ProductItemModel product;
  final bool isLoading;

  const CurrentlyTrendingItem({
    super.key,
    required this.product,
    required this.isLoading,
  });

  /// المقاس اللي بيتعرض سعره في البطاقة: الأرخص بعد الخصم (نفس from_price).
  ProductSizeModel? get _displaySize {
    if (product.sizes.isEmpty) return null;
    return product.sizes.reduce(
      (a, b) => b.priceAfter < a.priceAfter ? b : a,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = _displaySize;
    final hasDiscount = size?.hasDiscount ?? false;
    final priceAfter = size?.priceAfter ?? product.fromPrice;

    return GestureDetector(
      onTap: isLoading
          ? null
          : () => context.push(
              "${Routes.home}/${Routes.productDetails}",
              extra: product.id,
            ),
      child: Container(
        width: 140.w,
        decoration: BoxDecoration(
          borderRadius: AppRadius.br16,
          color: Colors.transparent,
          border: Border.all(color: colorScheme.onSurfaceVariant.withAlpha(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AppImage.cachedNetwork(
                  product.image??"",
                  height: 145,
                  width: double.infinity,
                  borderRadius: AppRadius.only(
                    topLeft: const Radius.circular(12),
                    bottomRight: const Radius.circular(12),
                  ),
                ),

                if (hasDiscount)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: CircleAvatar(
                      backgroundColor: isLoading
                          ? Colors.transparent
                          : AppColors.error700,
                      radius: 13.r,
                      child: Text(
                        '${size!.discountPercent}%',
                        style: AppTextStyles.text10Bold,
                      ),
                    ),
                  ),
              ],
            ),

            6.verticalSpace,

            Padding(
              padding: paddingHorizontal(8),
              child: Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.text12Bold,
              ),
            ),

            2.verticalSpace,

            Padding(
              padding: paddingHorizontal(8),
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Text(
                      '$priceAfter EGP',
                      style: AppTextStyles.text12Bold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (hasDiscount) ...[
                    4.horizontalSpace,
                    Flexible(
                      child: Text(
                        '${size!.price}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: AppTextStyles.text12Regular.copyWith(
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppColors.primary,
                          decorationThickness: 1.8,
                          color: colorScheme.onSurfaceVariant.withAlpha(150),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            6.verticalSpace,

            Padding(
              padding: paddingHorizontal(8),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 14.sp),
                  2.horizontalSpace,
                  Expanded(
                    child: Text(
                      '${product.rating.toStringAsFixed(1)} (${product.reviews})',
                      style: AppTextStyles.text10Regular,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            8.verticalSpace,
          ],
        ),
      ),
    );
  }
}