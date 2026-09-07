import 'package:flutter/material.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_elevated_button_theme.dart';
import 'package:konoz/core/theme/app_input_decoration_theme.dart';
import 'package:konoz/core/theme/app_outline_button_theme.dart';
import 'package:konoz/core/theme/app_text_button_theme.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/theme/color_scheme.dart';

abstract class AppThemeData {
  static ThemeData get light => ThemeData(
    useMaterial3: true,

    colorScheme: lightColorScheme,
    fontFamily: 'Cairo',
    scaffoldBackgroundColor: AppColors.black,

    textTheme: TextTheme(
      bodyLarge: AppTextStyles.text14Bold.copyWith(color: AppColors.white),
      bodyMedium: AppTextStyles.text14Regular.copyWith(color: AppColors.white),
      bodySmall: AppTextStyles.text12Regular.copyWith(color: AppColors.white),
      labelLarge: AppTextStyles.text12Bold.copyWith(color: AppColors.white),
    ),

    splashFactory: NoSplash.splashFactory,
    elevatedButtonTheme: AppElevatedButtonTheme.light,
    outlinedButtonTheme: AppOutlinedButtonTheme.light,
    textButtonTheme: AppTextButtonTheme.light,
    inputDecorationTheme: AppInputDecorationTheme.light,

    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.black,
      surfaceTintColor: Colors.transparent,
    ),

    dividerColor: AppColors.neutral600,

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
    ),
  );
}
