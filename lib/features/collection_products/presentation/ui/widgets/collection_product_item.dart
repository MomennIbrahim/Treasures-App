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
import 'package:konoz/core/widgets/custom_rating_widget.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class CollectionProductItem extends StatelessWidget {
  final ProductItemModel product;
  final bool isLoading;

  const CollectionProductItem({
    super.key,
    required this.product,
    required this.isLoading,
  });

  /// المقاس اللي بيتعرض سعره في البطاقة: الأرخص بعد الخصم (نفس from_price).
  ProductSizeModel? get _displaySize {
    if (product.sizes.isEmpty) return null;
    return product.sizes.reduce((a, b) => b.priceAfter < a.priceAfter ? b : a);
  }

  bool get _inStock => product.sizes.any((size) => size.isSellable);

  @override
  Widget build(BuildContext context) {
    final size = _displaySize;
    final hasDiscount = size?.hasDiscount ?? false;
    final priceAfter = size?.priceAfter ?? product.fromPrice;
    final bool isLastFew =
        size?.status == "available" || size?.status == "out_of_stock";
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: isLoading
          ? null
          : () => context.push(
              '${Routes.collectionProducts}/${Routes.productDetails}',
              extra: product.id,
            ),
      child: Container(
        padding: paddingAll(12),
        decoration: BoxDecoration(
          borderRadius: AppRadius.br8,
          color: colorScheme.onSurface.withValues(alpha: 0.02),
          border: Border.all(color: AppColors.neutral500.withAlpha(40)),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                AppImage.cachedNetwork(
                  product.image ?? "",
                  width: 140,
                  height: 180,
                  fit: BoxFit.contain,
                ),
                Expanded(
                  child: Padding(
                    padding: paddingHorizontal(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.text12Bold,
                        ),
                        Row(
                          children: [
                            CustomRatingWidget(
                              initialRating: product.rating,
                              width: 12,
                            ),
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
                        2.verticalSpace,
                        Text(
                          '$priceAfter EGP',
                          style: AppTextStyles.text14Bold,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (hasDiscount)
                          Text(
                            LocaleKeys.product_details_menu_price.tr(
                              args: [size!.price.toString()],
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: AppTextStyles.text10Regular.copyWith(
                              decoration: TextDecoration.lineThrough,
                              decorationColor: AppColors.primary,
                              decorationThickness: 1.8,
                              color: AppColors.background,
                            ),
                          ),
                        2.verticalSpace,
                        Text(
                          "${LocaleKeys.product_details_sillage.tr()}: ${product.sillage} | ${LocaleKeys.product_details_longevity.tr()}: ${product.longevity}",
                          style: AppTextStyles.text10Regular.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        2.verticalSpace,
                        if (!isLastFew)
                          Text(
                            LocaleKeys.general_only_few_left.tr(),
                            style: AppTextStyles.text12Bold.copyWith(
                              color: AppColors.warning900,
                            ),
                          ),
                        2.verticalSpace,
                        if (!_inStock)
                          Text(
                            LocaleKeys.general_out_of_stock.tr(),
                            style: AppTextStyles.text12Bold.copyWith(
                              color: AppColors.error700,
                            ),
                          ),
                        4.verticalSpace,
                        if (product.sizes.isNotEmpty)
                          SizedBox(
                            height: 15.h,
                            child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (_, _) => Text(
                                " / ",
                                style: AppTextStyles.text10Bold.copyWith(
                                  color: AppColors.neutral600,
                                ),
                              ),
                              itemCount: product.sizes.length,
                              itemBuilder: (context, index) {
                                return Center(
                                  child: Text(
                                    product.sizes[index].label.toUpperCase(),
                                    style: AppTextStyles.text10Bold.copyWith(
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (hasDiscount)
              PositionedDirectional(
                top: 0,
                end: 0,
                child: Container(
                  padding: paddingSymmetric(8, 2),
                  decoration: BoxDecoration(
                    color: AppColors.error700,
                    borderRadius: AppRadius.br4,
                  ),
                  child: Text(
                    LocaleKeys.general_sale.tr(),
                    style: AppTextStyles.text10Bold.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
