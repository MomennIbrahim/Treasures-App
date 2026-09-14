import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/widgets/app_text_form_field.dart';

class PersonalInformationForm extends StatelessWidget {
  const PersonalInformationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextFormField(readOnly: true, label: "Name", hint: "Momen Ibrahim"),
        16.verticalSpace,
        AppTextFormField(
          readOnly: true,
          label: "Phone Number",
          hint: "01x xxxxxxxx",
          validator: (String? value) {
            return null;
          },
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          inputFormatters: [LengthLimitingTextInputFormatter(10)],
        ),
        16.verticalSpace,
        AppTextFormField(
          readOnly: true,
          label: "Email",
          hint: "7M4wZ@example.com",
        ),
      ],
    );
  }
}
