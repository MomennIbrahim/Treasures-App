import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/core/widgets/app_loading.dart';
import 'package:konoz/features/auth/presentation/controllers/send_otp/send_otp_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;

  const LoginButton({
    super.key,
    required this.formKey,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SendOtpCubit, SendOtpState, bool>(
      selector: (state) => state.isLoading,
      builder: (context, isLoading) {
        return isLoading
            ? AppLoading()
            : AppButton(
                label: LocaleKeys.auth_login,
                borderRadius: AppRadius.br8,
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.read<SendOtpCubit>().sendOtp(
                      rawPhone: phoneController.text,
                    );
                  }
                },
              );
      },
    );
  }
}
