import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';
import 'package:konoz/features/home/data/model/packages_model.dart';

class PackageItem extends StatelessWidget {
  final PackageItemModel package;
  final bool isLoading;

  const PackageItem({
    super.key,
    required this.package,
    required this.isLoading,
  });

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
            package.image,
            height: 160,
            width: 150,
            borderRadius: AppRadius.only(
              topLeft: const Radius.circular(12),
              bottomLeft: const Radius.circular(12),
            ),
          ),

          Expanded(
            child: Padding(
              padding: paddingSymmetric(10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.text12Bold,
                  ),

                  5.verticalSpace,

                  Text(
                    '${package.discountPrice} L.E (${package.size})',
                    style: AppTextStyles.text14Bold.copyWith(
                      color: Colors.amber,
                    ),
                  ),

                  2.verticalSpace,
                  Text(
                    'Big Sale Up to ${package.discountPercentage}% Off on this package',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.text10Bold.copyWith(
                      color: Colors.amber,
                    ),
                  ),
                  2.verticalSpace,

                  Text(
                    package.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.text10Bold.copyWith(),
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
