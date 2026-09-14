import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';

class ConfirmLocationButton extends StatelessWidget {
  const ConfirmLocationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom,
      left: 16.w,
      right: 16.w,
      child: Center(
        child: Container(
          padding: paddingAll(16),
          margin: paddingAll(16),
          decoration: BoxDecoration(
            color: AppColors.success800,
            borderRadius: AppRadius.br8,
          ),
          child: Text(
            "Confirm Location",
            style: AppTextStyles.text12Bold.copyWith(color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
