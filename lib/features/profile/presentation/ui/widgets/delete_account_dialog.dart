import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/widgets/show_blurred_confirmation_dialog.dart';
import 'package:konoz/generated/locale_keys.g.dart';

void showDeleteAccountDialog(BuildContext context) {
  showBlurredConfirmationDialog(
    context: context,
    title:  LocaleKeys.dialogs_delete_account_title,
    message:
        LocaleKeys.dialogs_delete_account_message,
    confirmText: LocaleKeys.dialogs_delete_account_confirm,
    confirmColor: AppColors.error700,
    onConfirm: () => _handleDeleteAccount(context),
  );
}

void _handleDeleteAccount(BuildContext context) {
  context.push(Routes.auth);
  // مثال: context.read<AuthCubit>().deleteAccount();
}
