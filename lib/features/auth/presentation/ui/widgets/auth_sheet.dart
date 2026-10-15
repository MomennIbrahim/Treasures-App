import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/di/dependency_injection.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_pin_field.dart';
import 'package:konoz/core/widgets/app_text_rich.dart';
import 'package:konoz/features/auth/presentation/controllers/google_signin/google_sign_in_cubit.dart';
import 'package:konoz/features/auth/presentation/controllers/send_otp/send_otp_cubit.dart';
import 'package:konoz/features/auth/presentation/controllers/verify_otp/verify_otp_cubit.dart';
import 'package:konoz/features/auth/presentation/ui/widgets/auth_form.dart';
import 'package:konoz/features/auth/presentation/ui/widgets/google_sign_in_bloc_listener.dart';
import 'package:konoz/features/auth/presentation/ui/widgets/login_button.dart';
import 'package:konoz/features/auth/presentation/ui/widgets/send_otp_bloc_listener.dart';
import 'package:konoz/features/auth/presentation/ui/widgets/verify_otp_bloc_listener.dart';
import 'package:konoz/features/cart/presentation/controller/cart/cart_cubit.dart';
import 'package:konoz/features/profile/presentation/controllers/profile/profile_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// بيفتح شاشة اللوجين كـ bottom sheet.
/// بيرجّع `true` لو اليوزر سجّل دخول بنجاح، و`false` لو قفلها.
Future<bool> showLoginSheet(BuildContext context) async {
  final result = await showModalBottomSheet<bool>(
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
    builder: (_) => const LoginSheet(),
  );
  return result ?? false;
}

class LoginSheet extends StatefulWidget {
  const LoginSheet({super.key});

  @override
  State<LoginSheet> createState() => _LoginSheetState();
}

class _LoginSheetState extends State<LoginSheet> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  /// null = خطوة الرقم، غير null = خطوة الـ OTP
  String? _phone;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onLoggedIn() {
    getIt<ProfileCubit>().getProfile();
    getIt<CartCubit>().loadCount();
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<SendOtpCubit>()),
        BlocProvider(create: (_) => getIt<VerifyOtpCubit>()),
        BlocProvider(create: (_) => getIt<GoogleSignInCubit>()),
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
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                alignment: Alignment.topCenter,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  layoutBuilder: (current, previous) => Stack(
                    alignment: Alignment.topCenter,
                    children: [...previous, ?current],
                  ),
                  child: _phone == null
                      ? _PhoneStep(
                          key: const ValueKey('phone-step'),
                          formKey: _formKey,
                          phoneController: _phoneController,
                        )
                      : _OtpStep(
                          key: const ValueKey('otp-step'),
                          phone: _phone!,
                          onBack: () => setState(() => _phone = null),
                        ),
                ),
              ),
              // الـ listeners برة الـ switcher عشان تفضل شغالة بين الخطوتين
              SendOtpBlocListener(
                onCodeSent: (phone) => setState(() => _phone = phone),
              ),
              VerifyOtpBlocListener(onSuccess: _onLoggedIn),
              GoogleSignInBlocListener(onSuccess: _onLoggedIn),
              24.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

class _PhoneStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;

  const _PhoneStep({
    super.key,
    required this.formKey,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
        AppRichText(
          normalText: "Get Started Now With ",
          normalStyle: AppTextStyles.text18Bold,
          actionText: "Konoz!",
          actionStyle: AppTextStyles.text18Bold.copyWith(
            color: AppColors.primary,
          ),
        ),
        4.verticalSpace,
        Text(
          "Discover the best products from around the world",
          style: AppTextStyles.text12Regular,
        ),
        24.verticalSpace,
        AuthForm(formKey: formKey, phoneController: phoneController),
        24.verticalSpace,
        LoginButton(formKey: formKey, phoneController: phoneController),
        16.verticalSpace,
        Text(
          LocaleKeys.auth_or_login_with.tr(),
          style: AppTextStyles.text12Regular,
        ),
        //  GoogleAuthButton(),
      ],
    );
  }
}

class _OtpStep extends StatefulWidget {
  final String phone;
  final VoidCallback onBack;

  const _OtpStep({super.key, required this.phone, required this.onBack});

  @override
  State<_OtpStep> createState() => _OtpStepState();
}

class _OtpStepState extends State<_OtpStep> {
  late final PinInputController _pinFieldController;

  @override
  void initState() {
    super.initState();
    _pinFieldController = PinInputController();
  }

  @override
  void dispose() {
    _pinFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.topStart,
          child: IconButton(
            onPressed: widget.onBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        8.verticalSpace,
        AppRichText(
          normalText: LocaleKeys.auth_otp_title_normal.tr(),
          normalStyle: AppTextStyles.text18Bold,
          actionText: LocaleKeys.auth_otp_title_action.tr(),
          actionStyle: AppTextStyles.text18Bold.copyWith(
            color: AppColors.primary,
          ),
        ),
        Text(
          "${LocaleKeys.auth_otp_subtitle.tr()}*******${widget.phone.substring(10)}",
          style: AppTextStyles.text18Bold,
        ),
        8.verticalSpace,
        Text(
          LocaleKeys.auth_otp_description.tr(),
          style: AppTextStyles.text12Regular,
          textAlign: TextAlign.center,
        ),
        32.verticalSpace,
        AppPinField(
          controller: _pinFieldController,
          length: 6,
          onCompleted: (v) => context.read<VerifyOtpCubit>().verifyOtp(
            phone: widget.phone,
            code: v,
          ),
        ),
      ],
    );
  }
}
