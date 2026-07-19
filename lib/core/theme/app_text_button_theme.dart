import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_text_style.dart';
 

abstract class AppTextButtonTheme {
  static final light = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      minimumSize: Size(double.infinity, 36.0.h),
      textStyle: AppTextStyles.text14Bold,
      padding: paddingHorizontal(20),
    ),
  );
}
