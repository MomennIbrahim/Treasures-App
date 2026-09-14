import 'package:flutter/material.dart';

import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/theme/color_scheme.dart';

abstract class AppInputDecorationTheme {
  static final light = InputDecorationTheme(
    filled: true,
    fillColor: lightColorScheme.onSurface.withValues(alpha: 0.05),

    contentPadding: paddingSymmetric(16, 14),

    hintStyle: AppTextStyles.text12Regular.copyWith(
      color: lightColorScheme.onSurface.withValues(alpha: 0.5),
    ),

    errorStyle: AppTextStyles.text10Bold.copyWith(
      color: lightColorScheme.error,
    ),

    border: OutlineInputBorder(
      borderRadius: AppRadius.br12,
      borderSide: BorderSide.none,
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius: AppRadius.br12,
      borderSide: BorderSide.none,
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: AppRadius.br12,
      borderSide: BorderSide(
        color: lightColorScheme.primary,
        width: 1.5,
      ),
    ),

    errorBorder: OutlineInputBorder(
      borderRadius: AppRadius.br12,
      borderSide: BorderSide(
        color: lightColorScheme.error,
      ),
    ),

    focusedErrorBorder: OutlineInputBorder(
      borderRadius: AppRadius.br12,
      borderSide: BorderSide(
        color: lightColorScheme.error,
        width: 1.5,
      ),
    ),
  );

  static final dark = InputDecorationTheme(
    filled: true,
    fillColor: darkColorScheme.onSurface.withValues(alpha: 0.05),

    contentPadding: paddingSymmetric(16, 14),

    hintStyle: AppTextStyles.text12Regular.copyWith(
      color: darkColorScheme.onSurface.withValues(alpha: 0.5),
    ),

    errorStyle: AppTextStyles.text10Bold.copyWith(
      color: darkColorScheme.error,
    ),

    border: OutlineInputBorder(
      borderRadius: AppRadius.br12,
      borderSide: BorderSide.none,
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius: AppRadius.br12,
      borderSide: BorderSide.none,
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: AppRadius.br12,
      borderSide: BorderSide(
        color: darkColorScheme.primary,
        width: 1.5,
      ),
    ),

    errorBorder: OutlineInputBorder(
      borderRadius: AppRadius.br12,
      borderSide: BorderSide(
        color: darkColorScheme.error,
      ),
    ),

    focusedErrorBorder: OutlineInputBorder(
      borderRadius: AppRadius.br12,
      borderSide: BorderSide(
        color: darkColorScheme.error,
        width: 1.5,
      ),
    ),
  );
}