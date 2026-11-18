// core/widgets/app_password_field.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/widgets/app_text_form_field.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class AppPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? label;
  final String hint;

  const AppPasswordField({
    super.key,
    required this.controller,
    this.validator,
    this.label,
    this.hint = '*************',
  });

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: widget.controller,
      label: widget.label ?? LocaleKeys.auth_password.tr(),
      hint: widget.hint,
      obscureText: _obscure,
      keyboardType: TextInputType.visiblePassword,
      validator: widget.validator,
      suffixIcon: IconButton(
        onPressed: () => setState(() => _obscure = !_obscure),
        icon: HugeIcon(
          icon: _obscure
              ? HugeIcons.strokeRoundedViewOffSlash
              : HugeIcons.strokeRoundedView,
          size: 18.sp,
          color: AppColors.neutral600,
        ),
      ),
    );
  }
}
