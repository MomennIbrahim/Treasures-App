import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';

enum AppToastType { success, error, warning }

enum AppToastPosition { top, bottom }

class AppToast {
  static void show(
    BuildContext context, {
    required String message,
    AppToastType type = AppToastType.success,
    AppToastPosition position = AppToastPosition.bottom,
  }) {
    final config = _getConfig(type);
    final overlay = Overlay.of(context);

    late OverlayEntry overlayEntry;

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
          Flexible(
            child: Text(
              message,
              style: AppTextStyles.text12Bold.copyWith(color: AppColors.white),
            ),
          ),
          8.horizontalSpace,
          GestureDetector(
            onTap: () => overlayEntry.remove(),
            child: Text(
              "Undo",
              style: AppTextStyles.text12Bold.copyWith(
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
                  ? FadeInDownBig(child: toast)
                  : FadeInUpBig(child: toast),
            ),
          ),
        );
      },
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
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
