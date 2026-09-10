import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class AppPinField extends StatelessWidget {
  final int length;
  final PinInputController controller;
  final void Function(String)? onCompleted;
  final void Function(String)? onChanged;
  final bool obscureText;
  final bool autoFocus;
  final TextInputType keyboardType;

  const AppPinField({
    super.key,
    required this.controller,
    this.length = 4,
    this.onCompleted,
    this.onChanged,
    this.obscureText = true,
    this.autoFocus = true,
    this.keyboardType = TextInputType.number,
  });

  @override
  Widget build(BuildContext context) {
    return PinInput(
      length: length,
      autoFocus: autoFocus,
      keyboardType: keyboardType,
      autoDismissKeyboard: true,
      pinController: controller,
      onCompleted: onCompleted,
      onChanged: onChanged,
      builder: (context, cells) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: cells.map((cell) {
            return Flexible(
              child: Container(
                margin: paddingHorizontal(4),
                width: 70.w,
                height: 45.w,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.br16,
                  color: AppColors.lightWhite,
                  border: Border.all(
                    color: cell.isFocused
                        ? AppColors.primary
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  cell.character ?? '',
                  style: AppTextStyles.text14Bold.copyWith(
                    color: cell.character == null
                        ? AppColors.black.withValues(alpha: 0.2)
                        : null,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
