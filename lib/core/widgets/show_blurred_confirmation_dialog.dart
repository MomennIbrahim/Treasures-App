import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/generated/locale_keys.g.dart';

Future<void> showBlurredConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmText,
  required VoidCallback onConfirm,
  Color confirmColor = AppColors.error700,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: title,
    barrierColor: Colors.black.withValues(alpha: 0.01),
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const SizedBox.shrink();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 6 * curved.value,
          sigmaY: 6 * curved.value,
        ),
        child: FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween(begin: 0.9, end: 1.0).animate(curved),
            child: Center(
              child: _DialogContent(
                title: title,
                message: message,
                confirmText: confirmText,
                confirmColor: confirmColor,
                onConfirm: onConfirm,
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _DialogContent extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final Color confirmColor;
  final VoidCallback onConfirm;

  const _DialogContent({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.confirmColor,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        margin: paddingHorizontal(24),
        padding: paddingAll(20),
        decoration: BoxDecoration(
          color: AppColors.lightWhite,
          borderRadius: AppRadius.br16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title.tr(), style: AppTextStyles.text18Bold),
            8.verticalSpace,
            Text(
              message.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.text12Regular,
            ),
            20.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: LocaleKeys.dialogs_cancel.tr(),
                    buttonColor: AppColors.lightWhite,
                    labelStyle: AppTextStyles.text14Bold.copyWith(
                      color: AppColors.primary,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: AppButton(
                    label: confirmText,
                    buttonColor: confirmColor,
                    onPressed: () {
                      context.pop();
                      onConfirm();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
