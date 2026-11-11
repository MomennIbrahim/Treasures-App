import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/package_details/data/model/package_details_model.dart';
import 'package:konoz/generated/locale_keys.g.dart';

/// الوصف + طريقة الاستخدام.
class PackageDescriptionSection extends StatelessWidget {
  final PackageDetailsModel package;

  const PackageDescriptionSection({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingOnly(left: 16, right: 16, top: 16),
      child: FadeInUp(
        from: 20,
        delay: const Duration(milliseconds: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.product_details_description.tr(),
              style: AppTextStyles.text14Bold,
            ),
            6.verticalSpace,
            Text(package.description, style: AppTextStyles.text12Regular),
            if (package.howToUse.isNotEmpty) ...[
              16.verticalSpace,
              Text(
                LocaleKeys.product_details_how_to_use.tr(),
                style: AppTextStyles.text14Bold,
              ),
              6.verticalSpace,
              for (var i = 0; i < package.howToUse.length; i++)
                Padding(
                  padding: paddingOnly(bottom: 4),
                  child: Text(
                    '${i + 1}. ${package.howToUse[i]}',
                    style: AppTextStyles.text12Regular,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
