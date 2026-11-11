import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/package_details/data/model/package_details_model.dart';

/// السعر (والقديم مشطوب) + زرار الإضافة للسلة.
class PackageBottomBar extends StatelessWidget {
  final PackageDetailsModel package;

  const PackageBottomBar({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: paddingSymmetric(16, 8),
        decoration: BoxDecoration(color: colorScheme.onSecondary),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${package.finalPrice} EGP',
                    style: AppTextStyles.text16Bold,
                  ),
                  if (package.hasDiscount)
                    Text(
                      '${package.price} EGP',
                      style: AppTextStyles.text12Regular.copyWith(
                        decoration: TextDecoration.lineThrough,
                        decorationColor: AppColors.primary,
                        color: colorScheme.onSurfaceVariant.withAlpha(150),
                      ),
                    ),
                ],
              ),
              16.horizontalSpace,
              Expanded(
                child: FilledButton(
                  // TODO: الإضافة للسلة (السلة دلوقتي بتدعم size_id بس)
                  onPressed: () {},
                  child: const Text('Add to cart'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
