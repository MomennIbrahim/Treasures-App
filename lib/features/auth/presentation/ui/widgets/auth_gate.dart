import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/di/dependency_injection.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/auth/presentation/ui/widgets/auth_sheet.dart';
import 'package:konoz/features/profile/presentation/controllers/profile/profile_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class AuthGate extends StatelessWidget {
  final Widget child;

  const AuthGate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (p, c) => p.isGuest != c.isGuest,
      builder: (context, state) {
        return state.isGuest ? const LoginRequiredView() : child;
      },
    );
  }
}

class LoginRequiredView extends StatelessWidget {
  const LoginRequiredView({super.key});

  Future<void> _login(BuildContext context) async {
    final user = await showRegisterSheet(context);
    // _onSuccess في الشيت بينادي getProfile، بس نأكد هنا كمان
    if (user != null) getIt<ProfileCubit>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: paddingHorizontal(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 64.h,
                  width: 64.w,
                  padding: paddingAll(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedUserCheck01,
                    color: AppColors.primary,
                    strokeWidth: 2,
                  ),
                ),
                16.verticalSpace,
                Text(
                  LocaleKeys.general_login_required_title.tr(),
                  style: AppTextStyles.text18Bold,
                  textAlign: TextAlign.center,
                ),
                8.verticalSpace,
                Text(
                  LocaleKeys.general_login_required_message.tr(),
                  style: AppTextStyles.text12Regular,
                  textAlign: TextAlign.center,
                ),
                24.verticalSpace,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    onPressed: () => _login(context),
                    child: Text(LocaleKeys.auth_login.tr()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
