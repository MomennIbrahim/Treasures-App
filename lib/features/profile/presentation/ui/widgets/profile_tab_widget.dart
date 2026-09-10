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

class ProfileTabWidget extends StatelessWidget {
  const ProfileTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: paddingVertical(16),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            _buildCustomTab(
              title: LocaleKeys.me_personal_data,
              icon: HugeIcons.strokeRoundedUser03,
            ),
            _buildCustomTab(
              title: LocaleKeys.me_orders,
              icon: HugeIcons.strokeRoundedDeliveryBox01,
              onTap: () => context.push(Routes.orders),
            ),
            _buildCustomTab(
              title: LocaleKeys.me_favorites,
              icon: HugeIcons.strokeRoundedFavouriteCircle,
            ),
            _buildCustomTab(
              title: LocaleKeys.me_settings,
              icon: HugeIcons.strokeRoundedSettings02,
              onTap: () => context.push(Routes.settings),
            ),

            Divider(color: AppColors.neutral600),
            _buildCustomTab(
              title: LocaleKeys.me_faq,
              icon: HugeIcons.strokeRoundedComment03,
            ),
            _buildCustomTab(
              title: LocaleKeys.me_community,
              icon: HugeIcons.strokeRoundedUserGroup,
            ),

            Container(
              padding: paddingAll(16),
              margin: paddingVertical(8),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.2),
                borderRadius: AppRadius.br12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedHeadphones,
                    color: AppColors.white,
                    size: 26.sp,
                  ),
                  6.horizontalSpace,
                  Text(
                    LocaleKeys.me_help_hint.tr(),
                    style: AppTextStyles.text12Bold,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildCustomTab({
    required String title,
    required List<List<dynamic>> icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: paddingHorizontal(12),
        margin: paddingVertical(8),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: AppRadius.br12,
        ),
        child: Row(
          children: [
            Container(
              padding: paddingAll(6),
              margin: paddingVertical(8),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: AppRadius.br12,
              ),
              child: HugeIcon(icon: icon, color: AppColors.white, size: 18.sp),
            ),
            6.horizontalSpace,
            Expanded(child: Text(title.tr(), style: AppTextStyles.text12Bold)),
            Container(
              padding: paddingAll(6),
              margin: paddingVertical(8),
              decoration: BoxDecoration(
                color: Colors.white10,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: AppColors.white,
                size: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
