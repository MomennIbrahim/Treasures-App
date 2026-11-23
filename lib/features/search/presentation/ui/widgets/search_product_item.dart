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

class SearchProductItem extends StatelessWidget {
  final ProductItemModel product;
  final bool isLoading;

  const SearchProductItem({
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
    final colorScheme = Theme.of(context).colorScheme;
    final size = _displaySize;
    final hasDiscount = size?.hasDiscount ?? false;

    // فيه خصم: السعر بعد الخصم + menu price متشطب. مفيش خصم: السعر العادي بس.
    final price = hasDiscount
        ? size!.priceAfter
        : (size?.price ?? product.fromPrice);

    return GestureDetector(
      onTap: isLoading
          ? null
          : () => context.push(
              '${Routes.home}/${Routes.productDetails}',
              extra: product.id,
            ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppRadius.br8,
          color: colorScheme.onSurface.withValues(alpha: 0.02),
          border: Border.all(color: AppColors.neutral500.withAlpha(40)),
        ),
        // الصورة تاخد طول الكارد اللي بيحدده المحتوى
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 110.w,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: AppImage.cachedNetwork(
                        product.image ?? "",
                        fit: BoxFit.cover,
                        borderRadius: AppRadius.only(
                          topLeft: const Radius.circular(4),
                          bottomLeft: const Radius.circular(4),
                        ),
                      ),
                    ),
                    // بادج الـ sale بيظهر بس لو فيه خصم
                    if (hasDiscount)
                      Positioned(
                        top: 4,
                        left: 4,
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
              Expanded(
                child: Padding(
                  padding: paddingAll(8),
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
                        '$price EGP',
                        style: AppTextStyles.text12Bold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (hasDiscount)
                        Text(
                          'menu price: ${size!.price} EGP',
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
                        _inStock ? 'delivery today 6pm' : 'out of stock',
                        style: AppTextStyles.text12Bold.copyWith(
                          color: _inStock
                              ? AppColors.success800
                              : AppColors.error700,
                        ),
                      ),
                      4.verticalSpace,
                      if (product.sizes.isNotEmpty)
                        SizedBox(
                          height: 20.h,
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (_, _) => 6.horizontalSpace,
                            itemCount: product.sizes.length,
                            itemBuilder: (context, index) {
                              return Center(
                                child: Text(
                                  product.sizes[index].label,
                                  style: AppTextStyles.text10Bold.copyWith(
                                    color: Colors.amber,
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
        ),
      ),
    );
  }
}
