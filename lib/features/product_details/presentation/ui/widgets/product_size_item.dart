import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/product_details/data/model/product_details_model.dart';

class ProductSizeItem extends StatelessWidget {
  final ProductSizeModel size;
  final bool isSelected;
  final VoidCallback? onTap;

  const ProductSizeItem({
    super.key,
    required this.size,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: isSelected ? 1 : 0),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          final backgroundColor = Color.lerp(
            Colors.white.withValues(alpha: 0.12),
            AppColors.primary,
            value,
          )!;

          final borderColor = Color.lerp(
            Colors.white.withValues(alpha: 0.20),
            AppColors.primary,
            value,
          )!;

          return Transform.scale(
            scale: 1.0 + (0.08 * value),
            child: ClipRRect(
              borderRadius: AppRadius.br8,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: paddingAll(8),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: AppRadius.br8,
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(
                          alpha: 0.35 * value,
                        ),
                        blurRadius: 12 * value,
                        spreadRadius: 2 * value,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      size.displayName,
                      style: AppTextStyles.text12Bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
