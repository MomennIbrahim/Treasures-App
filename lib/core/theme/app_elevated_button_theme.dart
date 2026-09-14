import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/theme/color_scheme.dart';

abstract class AppElevatedButtonTheme {
  static final light = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: lightColorScheme.primary,
      foregroundColor: lightColorScheme.onPrimary,
      minimumSize: Size(double.infinity, 36.h),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.br20,
      ),
      textStyle: AppTextStyles.text14Bold,
      padding: paddingHorizontal(20),
    ),
  );

  static final dark = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: darkColorScheme.primary,
      foregroundColor: darkColorScheme.onPrimary,
      minimumSize: Size(double.infinity, 36.h),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.br20,
      ),
      textStyle: AppTextStyles.text14Bold,
      padding: paddingHorizontal(20),
    ),
  );
}