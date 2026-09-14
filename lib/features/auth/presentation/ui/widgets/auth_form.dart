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
import 'package:konoz/core/widgets/app_image.dart';
import 'package:konoz/core/widgets/app_text_form_field.dart';

class AuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const AuthForm({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: AppTextFormField(
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
            color: AppColors.white,
          ),
        ),
        validator: validateEgyptianPhone,
      ),
    );
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
}
