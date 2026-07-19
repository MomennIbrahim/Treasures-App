import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
 

abstract class AppOutlinedButtonTheme {
  static final light = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.primary),
      minimumSize: Size(double.infinity, 36.h),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.br20),
      textStyle: AppTextStyles.text14Bold,
      padding: paddingHorizontal(20),
    ),
  );
}
