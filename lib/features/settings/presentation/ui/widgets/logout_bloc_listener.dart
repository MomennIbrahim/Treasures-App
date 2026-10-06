import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/core/widgets/show_loading_dialog.dart';
import 'package:konoz/features/settings/presentation/controllers/logout/logout_cubit.dart';

class LogoutBlocListener extends StatelessWidget {
  const LogoutBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state.isLoading) {
          showLoadingDialog(context);
        } else {
          hideLoadingDialog(context); // آمنة لو مفيش dialog مفتوح
        }
        if (state.isSuccess) {
          context.go(Routes.home);
        }
        if (state.isFailure) {
          AppToast.show(
            context,
            message: state.failure?.getAllError() ?? '',
            type: AppToastType.error,
          );
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
