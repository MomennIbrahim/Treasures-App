import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/core/widgets/app_text_form_field.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/core/widgets/show_loading_dialog.dart';
import 'package:konoz/features/profile/presentation/controllers/profile/profile_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';

/// نفس الاسم القديم. الخطوات:
/// تأكيد + كلمة المرور ← DELETE /auth/me ← مسح الجلسة ← شاشة الدخول.
/// [requirePassword] = false لو الحساب من غير كلمة مرور (جوجل).
Future<void> showDeleteAccountDialog(
  BuildContext context, {
  bool requirePassword = true,
}) async {
  final cubit = context.read<ProfileCubit>();

  final password = await showDialog<String>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (_) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: _DeleteAccountPasswordDialog(requirePassword: requirePassword),
    ),
  );
  if (password == null || !context.mounted) return;

  showLoadingDialog(context);
  await cubit.deleteAccount(password: password);
  if (!context.mounted) return;
  hideLoadingDialog(context);

  final state = cubit.state;
  if (state.actionStatus == ProfileActionStatus.success) {
    AppToast.show(
      context,
      message: LocaleKeys.personal_data_account_deleted.tr(),
      type: AppToastType.success,
    );
    // go مش push: عشان نمسح الـ stack بتاع الحساب المحذوف.
    context.go(Routes.auth);
  } else {
    AppToast.show(
      context,
      message: state.actionFailure?.getAllError() ?? '',
      type: AppToastType.error,
    );
  }
}

class _DeleteAccountPasswordDialog extends StatefulWidget {
  const _DeleteAccountPasswordDialog({required this.requirePassword});

  final bool requirePassword;

  @override
  State<_DeleteAccountPasswordDialog> createState() =>
      _DeleteAccountPasswordDialogState();
}

class _DeleteAccountPasswordDialogState
    extends State<_DeleteAccountPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  void _confirm() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(_password.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(LocaleKeys.dialogs_delete_account_title.tr()),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(LocaleKeys.dialogs_delete_account_message.tr()),
            if (widget.requirePassword) ...[
              const SizedBox(height: 16),
              AppTextFormField(
                controller: _password,
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _confirm(),
                validator: (v) => (v == null || v.isEmpty)
                    ? LocaleKeys.personal_data_required.tr()
                    : null,
                hint: LocaleKeys.personal_data_current_pass.tr(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ],
            24.verticalSpace,
            // الزرارين جنب بعض بنفس العرض
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    height: 37,
                    onPressed: () => context.pop(),
                    label: LocaleKeys.dialogs_cancel.tr(),
                    labelStyle: AppTextStyles.text12Bold,
                    variant: AppButtonVariant.outlined,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: AppButton(
                    height: 37,
                    onPressed: _confirm,
                    label: LocaleKeys.dialogs_delete_account_confirm.tr(),
                    labelStyle: AppTextStyles.text12Bold,
                    buttonColor: AppColors.error700,
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
