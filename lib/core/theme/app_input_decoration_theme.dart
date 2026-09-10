import 'package:flutter/material.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';

abstract class AppInputDecorationTheme {
  static final light = InputDecorationTheme(
    filled: true,
    contentPadding: paddingSymmetric(16, 14),
    hintStyle: AppTextStyles.text12Regular.copyWith(
      color: AppColors.neutral500,
    ),
    errorStyle: AppTextStyles.text10Bold.copyWith(color: AppColors.warning900),
    border: OutlineInputBorder(
      borderRadius: AppRadius.br12,
      borderSide: const BorderSide(color: Colors.transparent),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppRadius.br12,
      borderSide: const BorderSide(color: Colors.transparent),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppRadius.br12,
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: AppRadius.br12,
      borderSide: const BorderSide(color: AppColors.error700),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: AppRadius.br12,
      borderSide: const BorderSide(color: AppColors.error800, width: 1.5),
    ),
  );
}
