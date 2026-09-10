import 'package:flutter/material.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.br48,
      child: Container(
        padding: paddingHorizontal(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white12,
          borderRadius: AppRadius.br48,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.text12Bold.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
