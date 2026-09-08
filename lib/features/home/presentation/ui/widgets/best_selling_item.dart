import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';

class BestSellingItem extends StatelessWidget {
  final ProductItemModel product;
  final bool isLoading;

  const BestSellingItem({
    super.key,
    required this.product,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
            child: Container(
              padding: paddingAll(4),
              decoration: BoxDecoration(
                color: isLoading ? Colors.transparent : AppColors.primary,
                borderRadius: AppRadius.br12,
              ),
              child: Text('Best Seller', style: AppTextStyles.text10Bold),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: paddingSymmetric(8, 5),
              decoration: BoxDecoration(
                color: AppColors.black.withValues(alpha: .6),
                borderRadius: AppRadius.bottom(const Radius.circular(16)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
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

                      4.horizontalSpace,

                      if (product.discountPercentage!.isNotEmpty)
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
                  ),

                  2.verticalSpace,

                  Text(
                    product.name,
                    style: AppTextStyles.text12Bold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  2.verticalSpace,

                  Row(
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
