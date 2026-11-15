import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/constance/images_paths.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/validation/egyption_phone_validator.dart';
import 'package:konoz/core/validation/name_validator.dart';
import 'package:konoz/core/validation/password_validator.dart';
import 'package:konoz/core/widgets/app_image.dart';
import 'package:konoz/core/widgets/app_password_field.dart';
import 'package:konoz/core/widgets/app_text_form_field.dart';

class AuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final TextEditingController nameController;
  final TextEditingController passwordController;
  final bool isLogin;

  const AuthForm({
    super.key,
    required this.formKey,
    required this.phoneController,
    required this.nameController,
    required this.passwordController,
    required this.isLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          AppTextFormField(
            controller: phoneController,
            label: "Phone Number",
            hint: "01x xxxxxxxx",
            keyboardType: TextInputType.phone,
            fixedTextDirection: TextDirection.ltr,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            prefixIcon: _buildPhonePrefix(),
            suffixIcon: Padding(
              padding: paddingAll(14),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedSmartPhone02,
                size: 15.sp,
                color: AppColors.neutral600,
              ),
            ),
            validator: validateEgyptianPhone,
          ),
          if (!isLogin)
            AppTextFormField(
              controller: nameController,
              label: "Full Name",
              hint: "ex: User Name",
              keyboardType: TextInputType.name,
              validator: validateName,
              suffixIcon: Padding(
                padding: paddingAll(14),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedUser,
                  size: 15.sp,
                  color: AppColors.neutral600,
                ),
              ),
            ),
          AppPasswordField(
            controller: passwordController,
            validator: isLogin ? validateRequiredPassword : validateNewPassword,
          ),
        ],
      ),
    );
  }

  // _buildPhonePrefix زي ما هو من غير تغيير
}

Widget _buildPhonePrefix() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 12.w),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppImage.asset(
          ImagesPaths.egyptFlag,
          width: 20,
          borderRadius: AppRadius.br4,
          fit: BoxFit.cover,
        ),
        4.horizontalSpace,
        Text('+2', style: AppTextStyles.text12Bold),
        8.horizontalSpace,
        SizedBox(
          width: 1,
          height: 16.h,
          child: VerticalDivider(color: Colors.grey.shade300, thickness: 1),
        ),
      ],
    ),
  );
}
