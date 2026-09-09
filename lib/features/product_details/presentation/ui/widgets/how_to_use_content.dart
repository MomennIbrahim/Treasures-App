import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/product_details/data/model/product_details_model.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class HowToUseContent extends StatelessWidget {
  final HowToUseModel? howToUse;

  const HowToUseContent({super.key, required this.howToUse});

  @override
  Widget build(BuildContext context) {
    if (howToUse == null || howToUse!.steps.isEmpty) {
      return const SizedBox.shrink();
    }

    return FadeInLeft(
      child: Column(
        key: key,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.product_details_how_to_use.tr(),
            style: AppTextStyles.text16Bold,
          ),
          10.verticalSpace,
          ...howToUse!.steps.asMap().entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22.w,
                    height: 22.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${entry.key + 1}',
                      style: AppTextStyles.text10Bold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Text(
                      entry.value,
                      style: AppTextStyles.text12Regular.copyWith(height: 1.4),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
