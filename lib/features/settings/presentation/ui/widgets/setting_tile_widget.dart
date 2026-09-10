import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';

class SettingsTileWidget extends StatelessWidget {
  final List<List<dynamic>> icon;
  final String title;
  final VoidCallback onTap;
  final Color? titleColor;
  final Color? iconColor;

  const SettingsTileWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.titleColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.br12,
      onTap: onTap,
      child: Container(
        padding: paddingSymmetric(16, 14),
        margin: paddingVertical(8),
        decoration: BoxDecoration(
          color: AppColors.lightWhite,
          borderRadius: AppRadius.br12,
        ),
        child: Row(
          children: [
            HugeIcon(
              icon: icon,
              color: iconColor ?? AppColors.primary,
              size: 22,
            ),
            12.horizontalSpace,
            Expanded(
              child: Text(
                title.tr(),
                style: AppTextStyles.text14Regular.copyWith(
                  color: titleColor,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}