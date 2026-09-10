import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: paddingAll(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: AppRadius.br8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: paddingAll(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: AppRadius.br8,
            ),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedLocation01,
              color: AppColors.primary,
              size: 22.sp,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Home', style: AppTextStyles.text14Bold),
                    ),
                    Text(
                      'Edit',
                      style: AppTextStyles.text12Bold.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                6.verticalSpace,
                Text('Momen Ibrahim', style: AppTextStyles.text12Regular),
                4.verticalSpace,
                Text(
                  'Alexandria, Egypt',
                  style: AppTextStyles.text12Regular.copyWith(
                    color: Colors.white70,
                  ),
                ),
                4.verticalSpace,
                Text(
                  '+20 100 000 0000',
                  style: AppTextStyles.text12Regular.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
  ;
  }
}