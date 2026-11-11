import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/custom_rating_widget.dart';
import 'package:konoz/features/package_details/data/model/package_details_model.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class PackageInfoSection extends StatelessWidget {
  final PackageDetailsModel package;

  const PackageInfoSection({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingAll(16),
      child: FadeInUp(
        from: 20,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(package.name, style: AppTextStyles.text18Bold),
                  6.verticalSpace,
                  Text(
                    package.description,
                    style: AppTextStyles.text14Regular.copyWith(height: 1.7),
                  ),
                  6.verticalSpace,
                  Row(
                    children: [
                      CustomRatingWidget(initialRating: package.rate),
                      2.horizontalSpace,
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${package.rate} | ${package.reviewCount} ${LocaleKeys.product_details_reviews.tr()}',
                            style: AppTextStyles.text12Bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
