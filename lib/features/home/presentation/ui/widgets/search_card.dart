import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';

class SearchCard extends StatelessWidget {
  const SearchCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: paddingAll(16),
      padding: paddingAll(14),
      decoration: BoxDecoration(
        borderRadius: AppRadius.br20,
        color: AppColors.white.withValues(alpha: 0.100),
      ),
      child: Row(
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedSearch01,
            color: AppColors.neutral500,
            size: 16.sp,
          ),
          6.horizontalSpace,
          Text(
            'Search for perfumery or fragrances...',
            style: AppTextStyles.text12Regular.copyWith(
              color: AppColors.neutral500,
            ),
          ),
        ],
      ),
    );
  }
}
