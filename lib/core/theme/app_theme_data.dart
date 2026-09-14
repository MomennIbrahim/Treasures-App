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

    scaffoldBackgroundColor: lightColorScheme.surface,

    textTheme: TextTheme(
      titleSmall: AppTextStyles.text10Bold.copyWith(
        color: lightColorScheme.onSurface,
      ),
      bodyLarge: AppTextStyles.text14Bold.copyWith(
        color: lightColorScheme.onSurface,
      ),
      bodyMedium: AppTextStyles.text14Regular.copyWith(
        color: lightColorScheme.onSurface,
      ),
      bodySmall: AppTextStyles.text12Regular.copyWith(
        color: lightColorScheme.onSurface,
      ),
      labelLarge: AppTextStyles.text12Bold.copyWith(
        color: lightColorScheme.onSurface,
      ),
    ),

    splashFactory: NoSplash.splashFactory,

    elevatedButtonTheme: AppElevatedButtonTheme.light,
    textButtonTheme: AppTextButtonTheme.light,
    outlinedButtonTheme: AppOutlinedButtonTheme.light,
    inputDecorationTheme: AppInputDecorationTheme.light,

    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: lightColorScheme.surface,
      foregroundColor: lightColorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
    ),

    dividerColor: lightColorScheme.outline,

    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: lightColorScheme.primary,
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    fontFamily: 'Cairo',

    scaffoldBackgroundColor: AppColors.darkBackground,

    textTheme: TextTheme(
      titleSmall: AppTextStyles.text10Bold.copyWith(
        color: darkColorScheme.onSurface,
      ),
      bodyLarge: AppTextStyles.text14Bold.copyWith(
        color: darkColorScheme.onSurface,
      ),
      bodyMedium: AppTextStyles.text14Regular.copyWith(
        color: darkColorScheme.onSurface,
      ),
      bodySmall: AppTextStyles.text12Regular.copyWith(
        color: darkColorScheme.onSurface,
      ),
      labelLarge: AppTextStyles.text12Bold.copyWith(
        color: darkColorScheme.onSurface,
      ),
    ),

    splashFactory: NoSplash.splashFactory,

    elevatedButtonTheme: AppElevatedButtonTheme.dark,
    textButtonTheme: AppTextButtonTheme.dark,
    outlinedButtonTheme: AppOutlinedButtonTheme.dark,
    inputDecorationTheme: AppInputDecorationTheme.dark,

    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: darkColorScheme.surface,
      foregroundColor: darkColorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
    ),

    dividerColor: darkColorScheme.outline,

    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: darkColorScheme.primary,
    ),
  );
}
