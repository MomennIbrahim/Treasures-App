import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/widgets/show_blurred_confirmation_dialog.dart';
import 'package:konoz/generated/locale_keys.g.dart';

void showChangeLanguageDialog(BuildContext context) {
  showBlurredConfirmationDialog(
    context: context,
    title: LocaleKeys.dialogs_change_language_title,
    message: LocaleKeys.dialogs_change_language_message,
    confirmText: LocaleKeys.dialogs_change_language_confirm,
    confirmColor: AppColors.primary,
    onConfirm: () => _changeLanguage(context),
  );
}

Future<void> _changeLanguage(BuildContext context) async {
  final currentLocale = context.locale;
  final newLocale = currentLocale.languageCode == 'ar'
      ? const Locale('en')
      : const Locale('ar');

  await context.setLocale(newLocale);

  if (!context.mounted) return;

  context.go(Routes.home);
}
