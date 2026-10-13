import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/core/widgets/show_loading_dialog.dart';
import 'package:konoz/features/auth/presentation/controllers/verify_otp/verify_otp_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class VerifyOtpBlocListener extends StatelessWidget {
  /// بتتنادى بعد قفل الـ loading dialog لما التحقق ينجح.
  final VoidCallback onSuccess;

  const VerifyOtpBlocListener({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerifyOtpCubit, VerifyOtpState>(
      listener: (context, state) {
        if (state.isLoading) {
          showLoadingDialog(context);
        }
        if (state.isSuccess) {
          hideLoadingDialog(context);
          AppToast.show(context, message: "احصل علي هديتك", second: 3);
          onSuccess();
        } else if (state.isFailure) {
          hideLoadingDialog(context);
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