import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/package_details/data/model/package_details_model.dart';

/// اسم الباكدج (الوصف في قسم الوصف، والتقييم مش بيرجع من الـ API).
class PackageInfoSection extends StatelessWidget {
  final PackageDetailsModel package;

  const PackageInfoSection({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingAll(16),
      child: FadeInUp(
        from: 20,
        child: SizedBox(
          width: double.infinity,
          child: Text(package.name, style: AppTextStyles.text18Bold),
        ),
      ),
    );
  }
}
