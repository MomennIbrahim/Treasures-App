import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/widgets/show_blurred_confirmation_dialog.dart';
import 'package:konoz/features/settings/presentation/controllers/logout/logout_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';

void showLogoutDialog(BuildContext context) {
  final cubit = context.read<LogoutCubit>();

  showBlurredConfirmationDialog(
    context: context,
    title: LocaleKeys.dialogs_logout_title,
    message: LocaleKeys.dialogs_logout_message,
    confirmText: LocaleKeys.dialogs_logout_confirm,
    confirmColor: AppColors.error700,
    onConfirm: () => _handleLogout(cubit),
  );
}

void _handleLogout(LogoutCubit cubit) {
  cubit.logout();
}
