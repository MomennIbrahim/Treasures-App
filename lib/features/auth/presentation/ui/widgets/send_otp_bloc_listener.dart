import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/features/auth/presentation/controllers/send_otp/send_otp_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class SendOtpBlocListener extends StatelessWidget {
  /// بتتنادى لما الكود يتبعت، وبتاخد الرقم بعد الـ format.
  final ValueChanged<String> onCodeSent;

  const SendOtpBlocListener({super.key, required this.onCodeSent});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SendOtpCubit, SendOtpState>(
      listener: (context, state) {
        if (state.isSuccess) {
          final phone = state.phone; // لو phone مش nullable عندك، شيل السطر ده
          AppToast.show(context, message: "Your Otp is: 666666", second: 5);
          onCodeSent(phone);
        } else if (state.isFailure) {
          if (state.failure?.message.contains("provider") ?? false) {
            AppToast.show(
              context,
              message: LocaleKeys.auth_phone_unavailable.tr(),
              type: AppToastType.error,
            );
            return;
          }
          AppToast.show(
            context,
            message: state.failure?.message.toString() ?? "",
            type: AppToastType.error,
          );
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
