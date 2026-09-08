import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/product_details/data/model/product_details_model.dart';

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
          Text('Details', style: AppTextStyles.text16Bold),
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
