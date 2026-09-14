import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/product_details/data/model/product_details_model.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class DescriptionContent extends StatelessWidget {
  final ProductDetailsModel product;

  const DescriptionContent({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: Column(
        key: key,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.product_details_description.tr(),
            style: AppTextStyles.text16Bold,
          ),
          8.verticalSpace,
          Text(
            product.description,
            style: AppTextStyles.text12Regular.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}
