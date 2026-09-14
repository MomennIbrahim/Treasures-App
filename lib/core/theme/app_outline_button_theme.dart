import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/theme/color_scheme.dart';

abstract class AppOutlinedButtonTheme {
  static final light = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: lightColorScheme.primary,

      side: BorderSide(
        color: lightColorScheme.primary,
      ),

      minimumSize: Size(double.infinity, 36.h),

      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.br20,
      ),

      textStyle: AppTextStyles.text14Bold,

      padding: paddingHorizontal(20),
    ),
  );

  static final dark = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: darkColorScheme.primary,

      side: BorderSide(
        color: darkColorScheme.primary,
      ),

      minimumSize: Size(double.infinity, 36.h),

      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.br20,
      ),

      textStyle: AppTextStyles.text14Bold,

      padding: paddingHorizontal(20),
    ),
  );
}