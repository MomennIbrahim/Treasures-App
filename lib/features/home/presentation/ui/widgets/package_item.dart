import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';

class PackageItem extends StatelessWidget {
  const PackageItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: paddingHorizontal(16),
      decoration: BoxDecoration(
        borderRadius: AppRadius.br12,
        border: Border.all(
          width: 2,
          color: AppColors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppImage.cachedNetwork(
            height: 160,
            width: 150,
            borderRadius: AppRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            "https://i.pinimg.com/736x/ef/2f/76/ef2f767715a8c352f92e680c7e51013d.jpg",
          ),
          Expanded(
            child: Padding(
              padding: paddingSymmetric(10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "5 Men's Perfumes That Smell Expensive (But Aren't)",
                    style: AppTextStyles.text12Bold,
                  ),
                  5.verticalSpace,
                  Text(
                    "2500 L.E (100 ML)",
                    style: AppTextStyles.text14Bold.copyWith(
                      color: Colors.amber,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    "Big Sale Up to 50% Off on All Fragrances",
                    style: AppTextStyles.text10Bold.copyWith(
                      color: Colors.amber,
                    ),
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
