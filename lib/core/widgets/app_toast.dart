import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/generated/locale_keys.g.dart';

enum AppToastType { success, error, warning }

enum AppToastPosition { top, bottom }

class AppToast {
  static void show(
    BuildContext context, {
    required String message,
    AppToastType type = AppToastType.success,
    AppToastPosition position = AppToastPosition.bottom,
    void Function()? onTap,
  }) {
    final config = _getConfig(type);
    final overlay = Overlay.of(context);

    late OverlayEntry overlayEntry;

    void removeToast() {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    }

    final toast = Container(
      padding: paddingAll(8),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: AppRadius.br16,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HugeIcon(icon: config.icon, size: 16.sp, color: AppColors.white),
          8.horizontalSpace,
          GestureDetector(
            onTap: () {
              onTap?.call();
              removeToast(); // يقفل التوست فورًا لما يدوس، من غير ما يستنى الـ duration
            },
            child: Flexible(
              child: Text(
                message,
                style: AppTextStyles.text12Bold.copyWith(
                  color: AppColors.white,
                  decoration: onTap != null ? TextDecoration.underline : null,
                  decorationColor: AppColors.white,
                ),
              ),
            ),
          ),
          8.horizontalSpace,
          GestureDetector(
            onTap: removeToast,
            child: Text(
              LocaleKeys.general_undo.tr(),
              style: AppTextStyles.text10Bold.copyWith(
                decoration: TextDecoration.underline,
                color: AppColors.black,
                decorationColor: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );

    overlayEntry = OverlayEntry(
      builder: (context) {
        final isTop = position == AppToastPosition.top;

        return Positioned(
          top: isTop ? MediaQuery.of(context).padding.top + 16.h : null,
          bottom: !isTop ? MediaQuery.of(context).padding.bottom + 16.h : null,
          left: 16.w,
          right: 16.w,
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: isTop
                  ? FadeInDown(
                      duration: const Duration(milliseconds: 250),
                      from:
                          30, // مسافة الحركة بالبكسل، صغيرة عشان تحس إنه طالع بسرعة
                      child: toast,
                    )
                  : FadeInUp(
                      duration: const Duration(milliseconds: 250),
                      from: 30,
                      child: toast,
                    ),
            ),
          ),
        );
      },
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), removeToast);
  }

  static _AppToastConfig _getConfig(AppToastType type) {
    switch (type) {
      case AppToastType.success:
        return _AppToastConfig(
          backgroundColor: AppColors.success800,
          icon: HugeIcons.strokeRoundedCheckmarkCircle01,
        );

      case AppToastType.error:
        return _AppToastConfig(
          backgroundColor: AppColors.error700,
          icon: HugeIcons.strokeRoundedCancelCircle,
        );

      case AppToastType.warning:
        return _AppToastConfig(
          backgroundColor: AppColors.warning900,
          icon: HugeIcons.strokeRoundedAlert02,
        );
    }
  }
}

class _AppToastConfig {
  final Color backgroundColor;
  final dynamic icon;

  const _AppToastConfig({required this.backgroundColor, required this.icon});
}