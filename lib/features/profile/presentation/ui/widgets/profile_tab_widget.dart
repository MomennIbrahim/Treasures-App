import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/helper/launch_service.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/profile/presentation/controllers/profile/profile_cubit.dart';
import 'package:konoz/features/profile/presentation/ui/widgets/delete_account_dialog.dart';
import 'package:konoz/features/profile/presentation/ui/widgets/logout_bloc_listener.dart';
import 'package:konoz/features/profile/presentation/ui/widgets/logout_dialog.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class ProfileTabWidget extends StatelessWidget {
  const ProfileTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isGuest = context.select<ProfileCubit, bool>((c) => c.state.isGuest);

    return SliverPadding(
      padding: paddingVertical(16),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            // تابس مرتبطة بالحساب: مش بتظهر للضيف
            if (!isGuest) ...[
              _buildCustomTab(
                context: context,
                title: LocaleKeys.me_personal_data,
                icon: HugeIcons.strokeRoundedUser03,
                onTap: () => context.push(
                  "${Routes.profile}/${Routes.personalData}",
                ),
              ),
              _buildCustomTab(
                context: context,
                title: LocaleKeys.me_orders,
                icon: HugeIcons.strokeRoundedDeliveryBox01,
                onTap: () =>
                    context.push("${Routes.profile}/${Routes.orders}"),
              ),
            ],
            _buildCustomTab(
              context: context,
              title: LocaleKeys.me_settings,
              icon: HugeIcons.strokeRoundedSettings02,
              onTap: () =>
                  context.push("${Routes.profile}/${Routes.settings}"),
            ),
            Divider(color: colorScheme.outline.withValues(alpha: 0.5)),
            _buildCustomTab(
              context: context,
              title: LocaleKeys.me_faq,
              icon: HugeIcons.strokeRoundedComment03,
              onTap: () => context.push("${Routes.profile}/${Routes.faq}"),
            ),
            _buildCustomTab(
              context: context,
              title: LocaleKeys.me_community,
              icon: HugeIcons.strokeRoundedUserGroup,
              onTap: () =>
                  context.push("${Routes.profile}/${Routes.community}"),
            ),
            if (!isGuest) ...[
              Divider(color: colorScheme.outline.withValues(alpha: 0.5)),
              _buildCustomTab(
                context: context,
                title: LocaleKeys.settings_logout,
                icon: HugeIcons.strokeRoundedLogout03,
                onTap: () => showLogoutDialog(context),
              ),
              _buildCustomTab(
                context: context,
                title: LocaleKeys.settings_delete_account,
                icon: HugeIcons.strokeRoundedDelete02,
                titleColor: AppColors.error700,
                iconColor: AppColors.error700,
                onTap: () => showDeleteAccountDialog(context),
              ),
            ],
            // بيفضل في الشجرة دايمًا عشان يلحق يسمع نتيجة اللوج أوت
            const LogoutBlocListener(),
            InkWell(
              onTap: () => LaunchService.call("+201211814372"),
              child: Container(
                padding: paddingAll(16),
                margin: paddingVertical(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.15),
                  borderRadius: AppRadius.br12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedHeadphones,
                      color: colorScheme.primary,
                      size: 26.sp,
                    ),
                    6.horizontalSpace,
                    Text(
                      LocaleKeys.me_help_hint.tr(),
                      style: AppTextStyles.text12Bold.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildCustomTab({
    required BuildContext context,
    required String title,
    required List<List<dynamic>> icon,
    VoidCallback? onTap,
    Color? titleColor,
    Color? iconColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: paddingHorizontal(12),
        margin: paddingVertical(8),
        decoration: BoxDecoration(
          color: colorScheme.onSurface.withValues(alpha: 0.05),
          borderRadius: AppRadius.br12,
        ),
        child: Row(
          children: [
            Container(
              padding: paddingAll(6),
              margin: paddingVertical(8),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: AppRadius.br12,
              ),
              child: HugeIcon(
                icon: icon,
                color: iconColor ?? colorScheme.onSurface,
                size: 18.sp,
              ),
            ),
            6.horizontalSpace,
            Expanded(
              child: Text(
                title.tr(),
                style: AppTextStyles.text12Bold.copyWith(
                  color: titleColor ?? colorScheme.onSurface,
                ),
              ),
            ),
            Container(
              padding: paddingAll(6),
              margin: paddingVertical(8),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: colorScheme.onSurface,
                size: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}