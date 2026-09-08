import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';

class IngredientsContent extends StatelessWidget {
  final List<String> ingredients;

  const IngredientsContent({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ingredients', style: AppTextStyles.text14Bold),
        10.verticalSpace,
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: List.generate(
            ingredients.length,
            (index) => ZoomIn(
              delay: Duration(milliseconds: 100 * index),
              child: Container(
                padding: paddingSymmetric(16, 12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: AppRadius.br8,
                ),
                child: Text(
                  ingredients[index],
                  style: AppTextStyles.text12Bold.copyWith(
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
