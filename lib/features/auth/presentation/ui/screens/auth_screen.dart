import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/constance/images_paths.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/core/widgets/app_image.dart';
import 'package:konoz/core/widgets/app_text_rich.dart';
import 'package:konoz/features/auth/presentation/ui/widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: paddingHorizontal(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              50.verticalSpace,
              Container(
                height: 45.h,
                width: 45.w,
                padding: paddingAll(12),
                margin: paddingOnly(bottom: 10),
                decoration: BoxDecoration(
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
              48.verticalSpace,
              AuthForm(formKey: _formKey),
              48.verticalSpace,
              AppButton(label: "Login", onPressed: () {
                    if (_formKey.currentState!.validate()) {
                    context.push(Routes.otp);
                  }
              }),
              24.verticalSpace,
              Text("Or Login with"),
              InkWell(
                onTap: () => context.push(Routes.home),
                child: Container(
                  padding: paddingAll(12),
                  margin: paddingAll(12),
                  decoration: BoxDecoration(
                    color: AppColors.lightWhite,
                    borderRadius: AppRadius.br12,
                  ),
                  child: AppImage.asset(
                    ImagesPaths.google,
                    width: 24,
                    borderRadius: AppRadius.br24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
