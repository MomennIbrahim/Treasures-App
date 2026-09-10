import 'package:easy_localization/easy_localization.dart';
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
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class CurrentlyTrendingItem extends StatelessWidget {
  final ProductItemModel product;
  final bool isLoading;

  const CurrentlyTrendingItem({
    super.key,
    required this.product,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push("${Routes.home}/${Routes.productDetails}"),
      child: Container(
        width: 140.w,
        decoration: BoxDecoration(
          borderRadius: AppRadius.br16,
          color: Colors.transparent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AppImage.cachedNetwork(
                  product.image,
                  height: 145,
                  width: double.infinity,
                  borderRadius: AppRadius.br16,
                ),

                if (product.discountPercentage!.isNotEmpty)
                  Positioned(
                    top: 4,
                    left: 4,
                    child: CircleAvatar(
                      backgroundColor: isLoading
                          ? Colors.transparent
                          : AppColors.error700,
                      radius: 12.r,
                      child: Text(
                        '${product.discountPercentage}%',
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
                      '${product.discountPrice} L.E',
                      style: AppTextStyles.text12Bold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  4.horizontalSpace,

                  Flexible(
                    child: Text(
                      '${product.price} L.E',
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
                    onTap: () {
                      AppToast.show(
                        context,
                        message: LocaleKeys.general_product_added_to_cart.tr(),
                        type: AppToastType.success,
                        onTap: () {
                          context.go(Routes.cart);
                        },
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: isLoading
                          ? Colors.transparent
                          : AppColors.primary.withValues(alpha: 0.9),
                      radius: 12.r,
                      child: isLoading
                          ? null
                          : HugeIcon(
                              icon: HugeIcons.strokeRoundedShoppingBagAdd,
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
