import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';

enum AppButtonVariant { filled, outlined }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.icon,
    this.width,
    this.height,
    this.buttonColor,
    this.padding,
    this.labelStyle,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final Color? buttonColor;
  final Widget? icon;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final TextStyle? labelStyle;

  bool get _isOutlined => variant == AppButtonVariant.outlined;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: SizedBox(
        width: width?.w.toDouble() ?? double.infinity,
        height: height?.h.toDouble() ?? 42.5.h,
        child: _isOutlined ? _buildOutlined() : _buildFilled(),
      ),
    );
  }

  Widget _buildFilled() {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor ?? AppColors.primary,
        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
        foregroundColor: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.br20),
      ),
      child: _buildChild(),
    );
  }

  Widget _buildOutlined() {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: BorderSide(color: AppColors.primary, width: 1.0),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.br20),
      ),
      child: _buildChild(),
    );
  }

  Widget _buildChild() {
    final style =
        labelStyle ??
        (variant == AppButtonVariant.outlined
            ? AppTextStyles.text14Bold.copyWith(color: AppColors.black)
            : AppTextStyles.text14Bold);

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          8.0.horizontalSpace,
          Text(label.tr(), style: style),
        ],
      );
    }

    return Text(label.tr(), style: style);
  }
}
