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
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/core/widgets/app_image.dart';
import 'package:konoz/core/widgets/app_toast.dart';
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

  bool get _hasDiscount =>
      product.discountPrice != null && product.discountPrice!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.push("${Routes.collectionProducts}/${Routes.productDetails}"),
      child: Container(
        width: 125.w,
        decoration: BoxDecoration(
          borderRadius: AppRadius.br4,
          color: Colors.white10,
        ),
        child: Row(
          children: [
            Stack(
              children: [
                AppImage.cachedNetwork(
                  product.image,
                  width: 130,
                  borderRadius: AppRadius.only(
                    topLeft: const Radius.circular(4),
                    bottomLeft: const Radius.circular(4),
                  ),
                ),
                if (_hasDiscount)
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: paddingSymmetric(8, 2),
                      decoration: BoxDecoration(
                        color: AppColors.error700,
                        borderRadius: AppRadius.br4,
                      ),
                      child: Text('Sale', style: AppTextStyles.text10Bold),
                    ),
                  ),
              ],
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
                          initialRating: double.tryParse(product.rating) ?? 0,
                          width: 12,
                        ),
                        2.horizontalSpace,
                        Expanded(
                          child: Text(
                            '${product.rating} (${product.reviewCount})',
                            style: AppTextStyles.text10Regular,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    2.verticalSpace,

                    Text(
                      '${_hasDiscount ? product.discountPrice : product.price} L.E',
                      style: AppTextStyles.text12Bold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    if (_hasDiscount)
                      Text(
                        'menu price: ${product.price} L.E',
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
                      product.inStock ? 'delivery today 6pm' : 'out of stock',
                      style: AppTextStyles.text12Bold.copyWith(
                        color: product.inStock
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
                          separatorBuilder: (context, index) =>
                              6.horizontalSpace,
                          itemCount: product.sizes.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: Text(
                                product.sizes[index].size,
                                style: AppTextStyles.text10Bold.copyWith(
                                  color: Colors.amber,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    6.verticalSpace,
                    if (product.inStock)
                      AppButton(
                        label: LocaleKeys.general_add_to_cart.tr(),
                        labelStyle: AppTextStyles.text12Bold,
                        onPressed: product.inStock
                            ? () {
                                AppToast.show(
                                  context,
                                  message: LocaleKeys
                                      .general_product_added_to_cart
                                      .tr(),
                                  type: AppToastType.success,
                                  onTap: () {
                                    context.go(Routes.cart);
                                  },
                                );
                              }
                            : null,
                        height: 30,
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
