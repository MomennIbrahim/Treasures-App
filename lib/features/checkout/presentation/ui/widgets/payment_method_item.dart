import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';

class PaymentMethodItem extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final IconData icon;
  final String title;
  final String subtitle;
  final ValueChanged<int> onTap;

  const PaymentMethodItem({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selectedIndex;

    return InkWell(
      borderRadius: AppRadius.br8,
      onTap: () => onTap(index),
      child: Container(
        padding: paddingAll(14),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.white24,
          ),
          borderRadius: AppRadius.br8,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.white,
              size: 24.sp,
            ),
            12.horizontalSpace,

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title.tr(), style: AppTextStyles.text14Bold),
                  4.verticalSpace,
                  Text(
                    subtitle.tr(),
                    style: AppTextStyles.text10Regular.copyWith(
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),

            Radio<int>(
              value: index,
              groupValue: selectedIndex,
              activeColor: AppColors.primary,
              onChanged: (value) {
                if (value != null) {
                  onTap(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
