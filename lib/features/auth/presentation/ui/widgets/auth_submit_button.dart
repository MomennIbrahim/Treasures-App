import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/core/widgets/app_loading.dart';
import 'package:konoz/features/auth/presentation/controllers/register_otp/register_cubit.dart';
import 'package:konoz/features/auth/presentation/controllers/login/login_cubit.dart';

class AuthSubmitButton extends StatelessWidget {
  final bool isLogin;
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController,
      nameController,
      passwordController;

  const AuthSubmitButton({
    super.key,
    required this.isLogin,
    required this.formKey,
    required this.phoneController,
    required this.nameController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final loading =
        context.select((LoginCubit c) => c.state.isLoading) ||
        context.select((RegisterCubit c) => c.state.isLoading);

    if (loading) return const AppLoading();

    return AppButton(
      label: isLogin ? "Login" : "Create account",
      borderRadius: AppRadius.br8,
      onPressed: () {
        if (!formKey.currentState!.validate()) return;
        if (isLogin) {
          context.read<LoginCubit>().login(
            rawPhone: phoneController.text,
            password: passwordController.text,
          );
        } else {
          context.read<RegisterCubit>().register(
            name: nameController.text.trim(),
            password: passwordController.text,
            rawPhone: phoneController.text,
          );
        }
      },
    );
  }
}
