import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/custom_back_icon.dart';

class MapHeader extends StatelessWidget {
  final String? addressResult;
  const MapHeader({super.key, required this.addressResult});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 16.w,
      right: 16.w,
      child: Row(
        children: [
          CustomBackIcon(),
          16.horizontalSpace,
          // بطاقة العنوان الحالي فوق
          if (addressResult != null)
            Expanded(
              child: Container(
                padding: paddingAll(16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  addressResult!,
                  style: AppTextStyles.text14Bold.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
