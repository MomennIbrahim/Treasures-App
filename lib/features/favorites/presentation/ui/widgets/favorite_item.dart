import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';

class FavoriteItem extends StatelessWidget {
  final ProductItemModel product;
  final bool isLoading;

  const FavoriteItem({
    super.key,
    required this.product,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => context.push("${Routes.home}/${Routes.productDetails}"),
      child: Container(
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
                  product.image,
                  height: 170,
                  width: double.infinity,
                  borderRadius: AppRadius.br16,
                ),

                if (product.defaultDiscountPercentage!.isNotEmpty)
                  Positioned(
                    top: 4,
                    left: 4,
                    child: CircleAvatar(
                      backgroundColor: isLoading
                          ? Colors.transparent
                          : AppColors.error700,
                      radius: 12.r,
                      child: Text(
                        '${product.defaultDiscountPercentage}',
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
                style: AppTextStyles.text14Bold,
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
                      '${product.defaultDiscountPrice}',
                      style: AppTextStyles.text12Bold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  4.horizontalSpace,

                  Flexible(
                    child: Text(
                      '${product.defaultDiscountPrice}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: AppTextStyles.text12Regular.copyWith(
                        decoration: TextDecoration.lineThrough,
                        decorationColor: AppColors.primary,
                        decorationThickness: 1.8,
                        color: AppColors.background,
                      ),
                    ),
                  ),
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
                      '${product.rating} (${product.reviewCount})',
                      style: AppTextStyles.text10Regular,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                    borderRadius: AppRadius.br48,
                    onTap: () {},
                    child: CircleAvatar(
                      backgroundColor: isLoading
                          ? Colors.transparent
                          : AppColors.primary.withValues(alpha: 0.9),
                      radius: 12.r,
                      child: isLoading
                          ? null
                          : HugeIcon(
                              icon: HugeIcons.strokeRoundedHeartRemove,
                              color: AppColors.white,
                              size: 13.sp,
                              strokeWidth: 2.5,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
