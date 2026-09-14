import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/widgets/show_blurred_confirmation_dialog.dart';
import 'package:konoz/generated/locale_keys.g.dart';

void showLogoutDialog(BuildContext context) {
  showBlurredConfirmationDialog(
    context: context,
    title: LocaleKeys.dialogs_logout_title,
    message:  LocaleKeys.dialogs_logout_message,
    confirmText:  LocaleKeys.dialogs_logout_confirm,
    confirmColor: AppColors.error700,
    onConfirm: () => _handleLogout(context),
  );
}

void _handleLogout(BuildContext context) {
  context.go(Routes.auth);
  // مثال: context.read<AuthCubit>().logout();
}
