import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/generated/locale_keys.g.dart';

typedef PasswordChange = ({String? currentPassword, String newPassword});

/// بيرجّع [PasswordChange] لو اليوزر أكّد، و null لو قفل.
/// [requireCurrent] = false لو الحساب من غير كلمة مرور (جوجل).
class ChangePasswordSheet extends StatefulWidget {
  const ChangePasswordSheet({super.key, this.requireCurrent = true});

  final bool requireCurrent;

  static Future<PasswordChange?> show(
    BuildContext context, {
    bool requireCurrent = true,
  }) {
    return showModalBottomSheet<PasswordChange>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => ChangePasswordSheet(requireCurrent: requireCurrent),
    );
  }

  @override
  State<ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _new = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _current.dispose();
    _new.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop<PasswordChange>((
      currentPassword: widget.requireCurrent ? _current.text : null,
      newPassword: _new.text,
    ));
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    bool last = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: _obscure,
      validator: validator,
      textInputAction: last ? TextInputAction.done : TextInputAction.next,
      onFieldSubmitted: last ? (_) => _submit() : null,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  LocaleKeys.me_change_password.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                16.verticalSpace,
                if (widget.requireCurrent) ...[
                  _field(
                    controller: _current,
                    label: LocaleKeys.personal_data_current_pass.tr(),
                    validator: (v) => (v == null || v.isEmpty)
                        ? LocaleKeys.personal_data_required.tr()
                        : null,
                  ),
                  12.verticalSpace,
                ],
                _field(
                  controller: _new,
                  label: LocaleKeys.personal_data_new_password.tr(),
                  validator: (v) => (v == null || v.length < 8)
                      ? LocaleKeys.personal_data_password_min.tr()
                      : null,
                ),
                12.verticalSpace,
                _field(
                  controller: _confirm,
                  label: LocaleKeys.personal_data_confirm_password.tr(),
                  last: true,
                  validator: (v) => v != _new.text
                      ? LocaleKeys.personal_data_password_mismatch.tr()
                      : null,
                ),
                20.verticalSpace,
                FilledButton(
                  onPressed: _submit,
                  child: Text(LocaleKeys.personal_data_save.tr()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}