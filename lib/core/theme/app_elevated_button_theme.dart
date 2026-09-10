import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
 

abstract class AppElevatedButtonTheme {
  static final dark = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      minimumSize: Size(double.infinity, 36.0.h),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.br20),
      textStyle: AppTextStyles.text14Bold,
      padding: paddingHorizontal(20),
    ),
  );
}
