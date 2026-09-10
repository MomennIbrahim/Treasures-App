import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';

class AppTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hint;
  final String? label;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;
  final bool readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool enabled;
  final FocusNode? focusNode;
  final String? initialValue;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final TextDirection? fixedTextDirection; // جديد

  const AppTextFormField({
    super.key,
    this.controller,
    this.hint,
    this.label,
    this.validator,
    this.onChanged,
    this.onTap,
    this.keyboardType,
    this.maxLines,
    this.minLines,
    this.readOnly = false,
    this.suffixIcon,
    this.prefixIcon,
    this.enabled = true,
    this.focusNode,
    this.initialValue,
    this.textInputAction,
    this.inputFormatters,
    this.fixedTextDirection, // جديد
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  TextDirection? _textDirection;
  bool _directionInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // لو فيه اتجاه ثابت متحدد، منعملش أي auto-detect خالص
    if (widget.fixedTextDirection != null) {
      _textDirection = widget.fixedTextDirection;
      _directionInitialized = true;
      return;
    }

    if (!_directionInitialized) {
      final text = widget.controller?.text ?? widget.initialValue ?? '';
      _textDirection = _getTextDirection(
        text,
        fallback: Directionality.of(context),
      );
      _directionInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveDirection =
        widget.fixedTextDirection ??
        _textDirection ??
        Directionality.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: AppTextStyles.text14Regular),
          8.verticalSpace,
        ],
        Directionality(
          textDirection: effectiveDirection,
          child: TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            validator: widget.validator,
            onTap: widget.onTap,
            readOnly: widget.readOnly,
            enabled: widget.enabled,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            inputFormatters: widget.inputFormatters,
            initialValue: widget.initialValue,
            textInputAction: widget.textInputAction,
            style: AppTextStyles.text12Regular,
            onChanged: (value) {
              // لو فيه اتجاه ثابت، منعملش أي إعادة حساب للاتجاه خالص
              if (widget.fixedTextDirection == null) {
                final newDirection = _getTextDirection(
                  value,
                  fallback: Directionality.of(context),
                );

                if (newDirection != _textDirection) {
                  setState(() {
                    _textDirection = newDirection;
                  });
                }
              }

              widget.onChanged?.call(value);
            },
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTextStyles.text12Regular.copyWith(
                color: Colors.white60,
              ),
              suffixIcon: widget.suffixIcon,
              prefixIcon: widget.prefixIcon,
              contentPadding: paddingSymmetric(16, 14),
              filled: true,
              fillColor: Colors.white30,
              enabledBorder: _buildOutlineBorder(),
              focusedBorder: _buildOutlineBorder(),
              errorBorder: _buildOutlineBorder(),
              focusedErrorBorder: _buildOutlineBorder(),
              disabledBorder: _buildOutlineBorder(),
            ),
          ),
        ),
      ],
    );
  }

  TextDirection _getTextDirection(
    String text, {
    required TextDirection fallback,
  }) {
    final trimmed = text.trimLeft();

    if (trimmed.isEmpty) {
      return fallback;
    }

    final firstChar = trimmed.characters.first;

    return RegExp(r'[A-Za-z]').hasMatch(firstChar)
        ? TextDirection.ltr
        : TextDirection.rtl;
  }

  OutlineInputBorder _buildOutlineBorder() {
    return OutlineInputBorder(
      borderRadius: AppRadius.br12,
      borderSide: const BorderSide(color: Colors.transparent, width: 1),
    );
  }
}
