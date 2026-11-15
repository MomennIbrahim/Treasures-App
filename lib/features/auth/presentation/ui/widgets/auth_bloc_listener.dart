import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/features/auth/data/model/user_model.dart';
import 'package:konoz/features/auth/presentation/controllers/register_otp/register_cubit.dart';
import 'package:konoz/features/auth/presentation/controllers/login/login_cubit.dart';

// auth_bloc_listener.dart
class AuthBlocListener extends StatelessWidget {
  final ValueChanged<AuthResponseModel> onSuccess;
  const AuthBlocListener({super.key, required this.onSuccess});

  void _error(BuildContext context, AppFailure? f) => AppToast.show(
        context,
        message: f?.getAllError().toString() ?? "",
        type: AppToastType.error,
      );

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginState>(
          listener: (context, s) {
            if (s.isSuccess && s.auth != null) onSuccess(s.auth!);
            if (s.isFailure) _error(context, s.failure);
          },
        ),
        BlocListener<RegisterCubit, RegisterState>(
          listener: (context, s) {
            if (s.isSuccess && s.auth != null) onSuccess(s.auth!);
            if (s.isFailure) _error(context, s.failure);
          },
        ),
      ],
      child: const SizedBox.shrink(),
    );
  }
}