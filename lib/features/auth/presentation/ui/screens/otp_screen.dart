import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_pin_field.dart';
import 'package:konoz/core/widgets/app_text_rich.dart';
import 'package:konoz/core/widgets/custom_back_icon.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: paddingHorizontal(16),
          child: Column(
            children: [
              Align(alignment: Alignment.topLeft, child: CustomBackIcon()),
              50.verticalSpace,
              AppRichText(
                normalText: "Enter Otp to ",
                normalStyle: AppTextStyles.text18Bold,
                actionText: "Verify ",
                actionStyle: AppTextStyles.text18Bold.copyWith(
                  color: AppColors.primary,
                ),
              ),
              Text("Your Phone Number 🔒", style: AppTextStyles.text18Bold),
              8.verticalSpace,
              Text(
                "A one-time password (OTP) has been sent to your phone number",
                style: AppTextStyles.text12Regular,
                textAlign: TextAlign.center,
              ),
              32.verticalSpace,
              AppPinField(
                controller: PinInputController(),
                length: 6,
                onCompleted: (v) => context.go(Routes.home),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
