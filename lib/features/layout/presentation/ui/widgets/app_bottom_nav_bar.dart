import 'dart:ui';

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

class AppBottomNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppBottomNavBar({super.key, required this.navigationShell});

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation:
          index == navigationShell.currentIndex &&
          GoRouterState.of(context).uri.path != Routes.home,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingOnly(bottom: 8, left: 16, right: 16),
      child: ClipRRect(
        borderRadius: AppRadius.br48,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.black.withValues(alpha: 0.55),
              borderRadius: AppRadius.br48,
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: MediaQuery.removePadding(
              context: context,
              removeBottom: true,
              child: BottomNavigationBar(
                currentIndex: navigationShell.currentIndex,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: AppColors.white,
                unselectedItemColor: AppColors.neutral500,
                selectedLabelStyle: AppTextStyles.text10Bold,
                unselectedLabelStyle: AppTextStyles.text10Regular,
                onTap: (index) => _onTap(context, index),
                items: [
                  BottomNavigationBarItem(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedHome09,
                      strokeWidth: 1.5,
                      size: 18.sp,
                    ),
                    label: LocaleKeys.layout_home.tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedShapeCollection,
                      strokeWidth: 1.5,
                      size: 18.sp,
                    ),
                    label: LocaleKeys.layout_collections.tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedShoppingBag01,
                      strokeWidth: 1.5,
                      size: 18.sp,
                    ),
                    label: LocaleKeys.layout_cart.tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedUser,
                      strokeWidth: 1.5,
                      size: 18.sp,
                    ),
                    label: LocaleKeys.layout_me.tr(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
