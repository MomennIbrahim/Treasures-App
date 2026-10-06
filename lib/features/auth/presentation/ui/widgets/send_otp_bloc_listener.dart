import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/features/auth/presentation/controllers/send_otp/send_otp_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class SendOtpBlocListener extends StatelessWidget {
  const SendOtpBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SendOtpCubit, SendOtpState>(
      listener: (context, state) {
        if (state.isSuccess) {
          AppToast.show(context, message: "Your Otp is: 666666", second: 5);
          context.push(Routes.otp, extra: state.phone);
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
