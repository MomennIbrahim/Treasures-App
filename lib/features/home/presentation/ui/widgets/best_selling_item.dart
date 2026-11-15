import 'package:easy_localization/easy_localization.dart';
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
import 'package:konoz/generated/locale_keys.g.dart';

class BestSellingItem extends StatelessWidget {
  final ProductItemModel product;
  final bool isLoading;

  const BestSellingItem({
    super.key,
    required this.product,
    required this.isLoading,
  });

  /// المقاس اللي بيتعرض سعره في البطاقة: الأرخص بعد الخصم (نفس from_price).
  ProductSizeModel? get _displaySize {
    if (product.sizes.isEmpty) return null;
    return product.sizes.reduce((a, b) => b.priceAfter < a.priceAfter ? b : a);
  }

  @override
  Widget build(BuildContext context) {
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
      child: SizedBox(
        width: 160.w,
        height: 200.h,
        child: Stack(
          children: [
            AppImage.cachedNetwork(
              product.image ?? "",
              width: double.infinity,
              height: double.infinity,
              borderRadius: AppRadius.br16,
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
                              '${product.rating.toStringAsFixed(1)} (${product.reviews})',
                              style: AppTextStyles.text10Regular.copyWith(
                                color: AppColors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          if (hasDiscount) ...[
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
                                '${size!.discountPercent}% OFF',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: AppTextStyles.text10Regular.copyWith(
                                  color: AppColors.white,
                                ),
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
                        style: AppTextStyles.text12Bold.copyWith(
                          color: AppColors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    2.verticalSpace,

                    Padding(
                      padding: paddingHorizontal(8),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              '$priceAfter L.E',
                              style: AppTextStyles.text12Bold.copyWith(
                                color: AppColors.white,
                              ),
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
                                  color: AppColors.background,
                                ),
                              ),
                            ),
                          ],
                        ],
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
                            bottomLeft: const Radius.circular(12),
                          ),
                        ),
                        child: Text(
                          LocaleKeys.home_best_selling.tr(),
                          style: AppTextStyles.text10Bold.copyWith(
                            color: AppColors.white,
                          ),
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
