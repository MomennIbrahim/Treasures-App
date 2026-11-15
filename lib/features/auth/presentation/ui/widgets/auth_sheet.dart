import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/di/dependency_injection.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_text_rich.dart';
import 'package:konoz/features/auth/data/model/user_model.dart';
import 'package:konoz/features/auth/presentation/controllers/login/login_cubit.dart';
import 'package:konoz/features/auth/presentation/controllers/register_otp/register_cubit.dart';
import 'package:konoz/features/auth/presentation/ui/widgets/auth_bloc_listener.dart';
import 'package:konoz/features/auth/presentation/ui/widgets/auth_form.dart';
import 'package:konoz/features/auth/presentation/ui/widgets/auth_submit_button.dart';
import 'package:konoz/features/cart/presentation/controller/cart/cart_cubit.dart';
import 'package:konoz/features/profile/presentation/controllers/profile/profile_cubit.dart';

/// بيرجّع بيانات اليوزر لو سجّل دخول/حساب، و null لو قفل الشيت.
Future<UserModel?> showRegisterSheet(BuildContext context) async {
  final user = await showModalBottomSheet<UserModel>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    constraints: const BoxConstraints(maxWidth: double.infinity),
    builder: (_) => const RegisterSheet(),
  );
  if (user != null && context.mounted) {
    await showAccountInfoDialog(context, user);
  }
  return user;
}

class RegisterSheet extends StatefulWidget {
  const RegisterSheet({super.key});
  @override
  State<RegisterSheet> createState() => _RegisterSheetState();
}

class _RegisterSheetState extends State<RegisterSheet> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _name = TextEditingController();
  final _password = TextEditingController();

  bool _isLogin = true; // اللوجن الأول

  @override
  void dispose() {
    _phone.dispose();
    _name.dispose();
    _password.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isLogin = !_isLogin);
    _formKey.currentState?.reset(); // يشيل رسائل الأخطاء
  }

  void _onSuccess(AuthResponseModel auth) {
    getIt<ProfileCubit>().getProfile();
    getIt<CartCubit>().loadCount();
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop(auth.user);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<LoginCubit>()),
        BlocProvider(create: (_) => getIt<RegisterCubit>()),
      ],
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          padding: paddingHorizontal(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              8.verticalSpace,
              Container(
                height: 45.h,
                width: 45.w,
                padding: paddingAll(12),
                margin: paddingOnly(bottom: 10),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedUserCheck01,
                  color: AppColors.white,
                  strokeWidth: 2,
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: AppRichText(
                  key: ValueKey(_isLogin),
                  normalText: _isLogin
                      ? "Welcome Back to "
                      : "Get Started Now With ",
                  normalStyle: AppTextStyles.text18Bold,
                  actionText: "Konoz!",
                  actionStyle: AppTextStyles.text18Bold.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              4.verticalSpace,
              Text(
                _isLogin
                    ? "Login to continue shopping"
                    : "Discover the best products from around the world",
                style: AppTextStyles.text12Regular,
              ),
              24.verticalSpace,
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                alignment: Alignment.topCenter,
                child: AuthForm(
                  formKey: _formKey,
                  phoneController: _phone,
                  nameController: _name,
                  passwordController: _password,
                  isLogin: _isLogin,
                ),
              ),
              24.verticalSpace,
              AuthSubmitButton(
                isLogin: _isLogin,
                formKey: _formKey,
                phoneController: _phone,
                nameController: _name,
                passwordController: _password,
              ),
              12.verticalSpace,
              TextButton(
                onPressed: _toggle,
                child: Text(
                  _isLogin
                      ? "Don't have an account? Create one"
                      : "Already have an account? Login",
                  style: AppTextStyles.text12Regular,
                ),
              ),
              AuthBlocListener(onSuccess: _onSuccess),
              24.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showAccountInfoDialog(BuildContext context, UserModel user) {
  // 201211814372 -> 01211814372
  final localPhone = user.phone.startsWith('20')
      ? '0${user.phone.substring(2)}'
      : user.phone;

  return showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 32.r,
            backgroundColor: AppColors.primary,
            backgroundImage: user.avatarUrl != null
                ? NetworkImage(user.avatarUrl!)
                : null,
            child: user.avatarUrl == null
                ? Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: AppTextStyles.text18Bold.copyWith(
                      color: AppColors.white,
                    ),
                  )
                : null,
          ),
          12.verticalSpace,
          Text('Hi, ${user.name}', style: AppTextStyles.text18Bold),
          4.verticalSpace,
          Text(localPhone, style: AppTextStyles.text12Regular),
          if (user.email != null)
            Text(user.email!, style: AppTextStyles.text12Regular),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Continue'),
        ),
      ],
    ),
  );
}
