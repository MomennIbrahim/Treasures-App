import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_pin_field.dart';
import 'package:konoz/core/widgets/app_text_rich.dart';
import 'package:konoz/core/widgets/custom_back_icon.dart';
import 'package:konoz/features/auth/presentation/controllers/verify_otp/verify_otp_cubit.dart';
import 'package:konoz/features/auth/presentation/ui/widgets/verify_otp_bloc_listener.dart';
import 'package:konoz/generated/locale_keys.g.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late final PinInputController _pinFieldController;

  @override
  void initState() {
    super.initState();
    _pinFieldController = PinInputController();
  }

  @override
  void dispose() {
    _pinFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: paddingHorizontal(16),
          child: Column(
            children: [
              const Align(
                alignment: AlignmentDirectional.topStart,
                child: CustomBackIcon(),
              ),
              50.verticalSpace,
              AppRichText(
                normalText: LocaleKeys.auth_otp_title_normal.tr(),
                normalStyle: AppTextStyles.text18Bold,
                actionText: LocaleKeys.auth_otp_title_action.tr(),
                actionStyle: AppTextStyles.text18Bold.copyWith(
                  color: AppColors.primary,
                ),
              ),
              Text(
                "${LocaleKeys.auth_otp_subtitle.tr()}*******${widget.phone.substring(10)}",
                style: AppTextStyles.text18Bold,
              ),
              8.verticalSpace,
              Text(
                LocaleKeys.auth_otp_description.tr(),
                style: AppTextStyles.text12Regular,
                textAlign: TextAlign.center,
              ),
              32.verticalSpace,
              AppPinField(
                controller: _pinFieldController,
                length: 6,
                onCompleted: (v) => context.read<VerifyOtpCubit>().verifyOtp(
                  phone: widget.phone,
                  code: v,
                ),
              ),
              const VerifyOtpBlocListener(),
            ],
          ),
        ),
      ),
    );
  }
}
