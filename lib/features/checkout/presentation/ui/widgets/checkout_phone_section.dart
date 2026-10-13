import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/validation/egyption_phone_validator.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/core/widgets/app_text_form_field.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/features/profile/presentation/controllers/profile/profile_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class CheckoutPhoneSection extends StatefulWidget {
  const CheckoutPhoneSection({super.key});

  @override
  State<CheckoutPhoneSection> createState() => _CheckoutPhoneSectionState();
}

class _CheckoutPhoneSectionState extends State<CheckoutPhoneSection> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final raw = _controller.text.trim();
    final error = validateEgyptianPhone(raw);
    if (error != null) {
      AppToast.show(context, message: error, type: AppToastType.error);
      return;
    }
    FocusScope.of(context).unfocus();
    // 01069528769 → 201069528769 (نفس شكل التخزين الحالي في profiles)
    context.read<ProfileCubit>().updatePhone('20${raw.substring(1)}');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (p, c) =>
          p.actionStatus != c.actionStatus &&
          c.action == ProfileAction.updatePhone &&
          c.actionStatus == ProfileActionStatus.failure,
      listener: (context, state) => AppToast.show(
        context,
        message:
            state.actionFailure?.getAllError() ??
            LocaleKeys.errors_errors_unexpected.tr(),
        type: AppToastType.error,
      ),
      child: BlocSelector<ProfileCubit, ProfileState, bool>(
        selector: (s) => s.isSuccess && (s.profile?.phone ?? '').trim().isEmpty,
        builder: (context, needsPhone) {
          if (!needsPhone) return const SizedBox.shrink();

          return Padding(
            padding: paddingOnly(top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.checkout_phone_title.tr(),
                  style: AppTextStyles.text16Bold,
                ),
                4.verticalSpace,
                Text(
                  LocaleKeys.checkout_phone_hint.tr(),
                  style: AppTextStyles.text12Regular,
                ),
                10.verticalSpace,
                AppTextFormField(
                  controller: _controller,
                  hint: '01xxxxxxxxx',
                  maxLines: 1,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _save(),
                ),
                10.verticalSpace,
                BlocSelector<ProfileCubit, ProfileState, bool>(
                  selector: (s) =>
                      s.actionStatus == ProfileActionStatus.loading &&
                      s.action == ProfileAction.updatePhone,
                  builder: (context, saving) => AppButton(
                    label: LocaleKeys.checkout_phone_save.tr(),
                    labelStyle: AppTextStyles.text12Bold,
                    onPressed: saving ? null : _save,
                    height: 40,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
