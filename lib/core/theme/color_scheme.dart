import 'package:flutter/material.dart';
import 'package:konoz/core/theme/app_colors.dart';
 
const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,

  // Primary
  primary: AppColors.primary,
  onPrimary: AppColors.white,

  // Secondary
  secondary: AppColors.white,
  onSecondary: AppColors.white,

  // Surface
  surface: AppColors.background,
  onSurface: AppColors.black,

  // Error
  error: AppColors.error800,
  onError: AppColors.white,
);
