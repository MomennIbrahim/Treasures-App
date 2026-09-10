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

class BestSellingItem extends StatelessWidget {
  final ProductItemModel product;
  final bool isLoading;

  const BestSellingItem({
    super.key,
    required this.product,
    required this.isLoading,
  });

  bool get _hasDiscount =>
      product.discountPrice != null && product.discountPrice!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('${Routes.home}/${Routes.productDetails}'),
      child: SizedBox(
        width: 160.w,
        height: 200.h,
        child: Stack(
          children: [
            AppImage.cachedNetwork(
              product.image,
              width: double.infinity,
              height: double.infinity,
              borderRadius: AppRadius.br16,
            ),

            Positioned(
              top: 4,
              left: 4,
              child: InkWell(
                borderRadius: AppRadius.br48,
                onTap: () {
                  AppToast.show(
                    context,
                    message: "Prodcut added to cart, Press to go to cart",
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
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: paddingOnly(top: 5),
                decoration: BoxDecoration(
                  color: AppColors.black.withValues(alpha: .6),
                  borderRadius: AppRadius.bottom(const Radius.circular(16)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
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

                          if (_hasDiscount &&
                              product.discountPercentage != null &&
                              product.discountPercentage!.isNotEmpty) ...[
                            4.horizontalSpace,
                            Container(
                              padding: paddingSymmetric(4, 1),
                              decoration: BoxDecoration(
                                color: isLoading
                                    ? Colors.transparent
                                    : AppColors.primary,
                                borderRadius: AppRadius.br4,
                              ),
                              child: Text(
                                '${product.discountPercentage}% OFF',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: AppTextStyles.text10Regular,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    2.verticalSpace,

                    Padding(
                      padding: paddingHorizontal(8),
                      child: Text(
                        product.name,
                        style: AppTextStyles.text12Bold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    2.verticalSpace,

                    if (_hasDiscount)
                      Padding(
                        padding: paddingHorizontal(8),
                        child: Row(
                          children: [
                            Flexible(
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
                      )
                    else
                      Padding(
                        padding: paddingHorizontal(8),
                        child: Text(
                          '${product.price} L.E',
                          style: AppTextStyles.text12Bold,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        padding: paddingAll(4),
                        margin: paddingOnly(top: 5),
                        decoration: BoxDecoration(
                          color: isLoading
                              ? Colors.transparent
                              : AppColors.error700,
                          borderRadius: AppRadius.only(
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        child: Text(
                          LocaleKeys.home_best_selling.tr(),
                          style: AppTextStyles.text10Bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
