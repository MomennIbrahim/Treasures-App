import 'package:flutter/material.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/widgets/app_button.dart';

class EditProfileInfoButton extends StatefulWidget {
  const EditProfileInfoButton({super.key});

  @override
  State<EditProfileInfoButton> createState() => _EditProfileInfoButtonState();
}

class _EditProfileInfoButtonState extends State<EditProfileInfoButton> {
  @override
  Widget build(BuildContext context) {
    return AppButton(
      padding: paddingOnly(left: 20, right: 20, bottom: 40, top: 20),
      label: "Update",
      onPressed: () {},
    );
  }
}
