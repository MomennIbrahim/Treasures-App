import 'package:flutter/material.dart';
import 'package:konoz/core/theme/app_colors.dart';

const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,

  // Primary
  primary: AppColors.primary,
  onPrimary: AppColors.white,

  // Secondary
  secondary: AppColors.black,
  onSecondary: AppColors.white,

  // Surface
  surface: AppColors.background,
  onSurface: AppColors.darkBackground,

  // Error
  error: AppColors.error700,
  onError: AppColors.white,
);

const ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,

  // Primary
  primary: AppColors.primary,
  onPrimary: AppColors.white,

  // Secondary
  secondary: AppColors.white,
  onSecondary: AppColors.darkBackground,

  // Surface
  surface: AppColors.black,
  onSurface: AppColors.white,

  // Error
  error: AppColors.error700,
  onError: AppColors.white,
);
