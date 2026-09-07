import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';

class BestSellingItem extends StatelessWidget {
  const BestSellingItem({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160.w,
      height: 200.h, // نفس ارتفاع الـ SizedBox بتاع الـ ListView بالظبط
      child: Stack(
        children: [
          AppImage.cachedNetwork(
            width: double.infinity,
            height: double.infinity, // تاخد كل ارتفاع وعرض الـ SizedBox
            borderRadius: AppRadius.br16,
            "https://i.pinimg.com/736x/52/21/7e/52217e4c3e4cbc9ef40e891b8e108f2e.jpg",
          ),
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: paddingAll(4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: AppRadius.br12,
              ),
              child: Text("Best Seller", style: AppTextStyles.text10Bold),
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
                borderRadius: AppRadius.bottom(Radius.circular(16)),
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
                          "4.5 (98)",
                          style: AppTextStyles.text10Regular,
                        ),
                      ),
                      4.horizontalSpace,
                      Container(
                        padding: paddingSymmetric(4, 1),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: AppRadius.br4,
                        ),
                        child: Text(
                          "35% OFF",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: AppTextStyles.text10Regular,
                        ),
                      ),
                    ],
                  ),
                  2.verticalSpace,
                  Text(
                    "Marshmallow 50ml sad as dssadsa as dsadasd sa d",
                    style: AppTextStyles.text12Bold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  2.verticalSpace,
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          "350 L.E",
                          style: AppTextStyles.text12Bold,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      4.horizontalSpace,
                      Flexible(
                        child: Text(
                          "500",
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
