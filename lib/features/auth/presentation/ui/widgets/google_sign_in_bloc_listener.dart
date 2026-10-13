import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/core/widgets/show_loading_dialog.dart';
import 'package:konoz/features/auth/presentation/controllers/google_signin/google_sign_in_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class GoogleSignInBlocListener extends StatelessWidget {
  /// بتتنادى بعد قفل الـ loading dialog لما الدخول بجوجل ينجح.
  /// (تحميل الـ profile والسلة بقى جوه الـ LoginSheet).
  final VoidCallback onSuccess;

  const GoogleSignInBlocListener({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GoogleSignInCubit, GoogleSignInState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.isLoading) {
          showLoadingDialog(context);
          return;
        }
        hideLoadingDialog(context);

        if (state.isFailure) {
          AppToast.show(
            context,
            message:
                state.failure?.getAllError() ??
                LocaleKeys.errors_errors_unexpected.tr(),
            type: AppToastType.error,
          );
        } else if (state.isSuccess) {
          onSuccess();
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
