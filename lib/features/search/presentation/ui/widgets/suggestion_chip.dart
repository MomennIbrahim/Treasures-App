import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';



class SuggestionChip extends StatelessWidget {
  const SuggestionChip({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.br24,
      child: Container(
        padding: paddingSymmetric(14, 8),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: AppRadius.br24,
          border: Border.all(color: AppColors.neutral600),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              color: AppColors.white,
              size: 12.sp,
            ),
            6.horizontalSpace,
            Text(label, style: AppTextStyles.text12Regular),
          ],
        ),
      ),
    );
  }
}
