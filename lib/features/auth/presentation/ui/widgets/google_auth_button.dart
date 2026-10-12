import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konoz/core/constance/images_paths.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/widgets/app_image.dart';
import 'package:konoz/features/auth/presentation/controllers/google_signin/google_sign_in_cubit.dart';

class GoogleAuthButton extends StatelessWidget {
  const GoogleAuthButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocSelector<GoogleSignInCubit, GoogleSignInState, bool>(
      selector: (s) => s.isLoading,
      builder: (context, loading) => InkWell(
        onTap: loading
            ? null
            : () => context.read<GoogleSignInCubit>().signIn(),
        child: Container(
          padding: paddingAll(12),
          margin: paddingAll(12),
          decoration: BoxDecoration(
            color: colorScheme.secondary.withValues(alpha: 0.05),
            borderRadius: AppRadius.br12,
          ),
          child: AppImage.asset(
            ImagesPaths.google,
            width: 24,
            borderRadius: AppRadius.br24,
          ),
        ),
      ),
    );
  }
}
