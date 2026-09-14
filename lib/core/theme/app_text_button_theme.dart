import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/theme/color_scheme.dart';

abstract class AppTextButtonTheme {
  static final light = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: lightColorScheme.primary,

      minimumSize: Size(double.infinity, 36.h),

      textStyle: AppTextStyles.text14Bold,

      padding: paddingHorizontal(20),
    ),
  );

  static final dark = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: darkColorScheme.primary,

      minimumSize: Size(double.infinity, 36.h),

      textStyle: AppTextStyles.text14Bold,

      padding: paddingHorizontal(20),
    ),
  );
}