import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/core/widgets/app_text_form_field.dart';
import 'package:konoz/features/profile/data/model/profile_model.dart';
import 'package:konoz/features/profile/presentation/controllers/profile/profile_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class PersonalInformationForm extends StatefulWidget {
  final ProfileModel profile;
  final bool isLoading;

  const PersonalInformationForm({
    super.key,
    required this.profile,
    required this.isLoading,
  });

  @override
  State<PersonalInformationForm> createState() =>
      _PersonalInformationFormState();
}

class _PersonalInformationFormState extends State<PersonalInformationForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.profile.name);
    _email = TextEditingController(text: widget.profile.email);
    _phone = TextEditingController(text: widget.profile.phone);
  }

  @override
  void didUpdateWidget(covariant PersonalInformationForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    // لما الداتا الحقيقية توصل بعد الـ skeleton (الـ id بيتغير من '' لقيمة)
    if (oldWidget.profile.id != widget.profile.id) {
      _name.text = widget.profile.name;
      _email.text = widget.profile.email;
      _phone.text = widget.profile.phone;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<ProfileCubit>().updateProfile(
      name: _name.text.trim(),
      email: _email.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextFormField(
            controller: _name,
            label: LocaleKeys.personal_data_name.tr(),
            hint: LocaleKeys.personal_data_name.tr(),
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? LocaleKeys.personal_data_required.tr()
                : null,
          ),
          16.verticalSpace,

          // الرقم: عرض فقط (مينفعش يتعدل)
          AppTextFormField(
            controller: _phone,
            readOnly: true,
            label: LocaleKeys.auth_phone_number.tr(),
            hint: LocaleKeys.auth_phone_hint.tr(),
            keyboardType: TextInputType.phone,
          ),
          16.verticalSpace,

          AppTextFormField(
            controller: _email,
            label: LocaleKeys.personal_data_email.tr(),
            hint: 'name@example.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
            validator: (v) {
              final value = v?.trim() ?? '';
              if (value.isEmpty) return null; // الإيميل اختياري
              final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
              return ok ? null : LocaleKeys.personal_data_invalid_email.tr();
            },
          ),
          24.verticalSpace,

          AppButton(
            label: LocaleKeys.personal_data_save.tr(),
            onPressed: widget.isLoading ? null : _save,
          ),
        ],
      ),
    );
  }
}
