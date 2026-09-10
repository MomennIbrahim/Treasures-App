import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class SearchCard extends StatelessWidget {
  final String? title;
  const SearchCard({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('${Routes.home}/${Routes.search}'),
      child: Container(
        margin: paddingSymmetric(16, 4),
        padding: paddingAll(14),
        decoration: BoxDecoration(
          borderRadius: AppRadius.br20,
          color: AppColors.white.withValues(alpha: 0.100),
        ),
        child: Row(
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              color: AppColors.neutral500,
              size: 16.sp,
            ),
            6.horizontalSpace,
            Text(
              title ?? LocaleKeys.general_search_hint.tr(),
              style: AppTextStyles.text12Regular.copyWith(
                color: AppColors.neutral500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
