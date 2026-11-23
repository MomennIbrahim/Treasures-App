import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/generated/locale_keys.g.dart';

typedef RefundRequestData = ({int amount, String reason});

/// بيرجّع null لو اليوزر قفل الشيت من غير ما يبعت.
Future<RefundRequestData?> showRefundRequestSheet(
  BuildContext context, {
  required int refundable,
}) {
  return showModalBottomSheet<RefundRequestData>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _RefundRequestSheet(refundable: refundable),
  );
}

class _RefundRequestSheet extends StatefulWidget {
  final int refundable;
  const _RefundRequestSheet({required this.refundable});

  @override
  State<_RefundRequestSheet> createState() => _RefundRequestSheetState();
}

class _RefundRequestSheetState extends State<_RefundRequestSheet> {
  static const _maxAmount = 100000000; // حد الـ API
  static const _maxReason = 1000;

  final _formKey = GlobalKey<FormState>();
  late final _amount = TextEditingController(
    text: widget.refundable > 0 ? '${widget.refundable}' : '',
  );
  final _reason = TextEditingController();

  int get _limit =>
      widget.refundable < _maxAmount ? widget.refundable : _maxAmount;

  @override
  void dispose() {
    _amount.dispose();
    _reason.dispose();
    super.dispose();
  }

  String? _validateAmount(String? v) {
    final value = int.tryParse((v ?? '').trim());
    if (value == null) return LocaleKeys.refund_amount_required.tr();
    if (value < 1 || value > _limit) {
      return LocaleKeys.refund_amount_invalid.tr(args: ['$_limit']);
    }
    return null;
  }

  String? _validateReason(String? v) =>
      (v ?? '').trim().isEmpty ? LocaleKeys.refund_reason_required.tr() : null;

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop((
      amount: int.parse(_amount.text.trim()),
      reason: _reason.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // الكيبورد
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: paddingAll(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.refund_sheet_title.tr(),
                style: AppTextStyles.text18Bold,
              ),
              4.verticalSpace,
              Text(
                LocaleKeys.refund_remaining.tr(args: ['${widget.refundable}']),
                style: AppTextStyles.text12Regular,
              ),
              16.verticalSpace,
              TextFormField(
                controller: _amount,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _validateAmount,
                decoration: InputDecoration(
                  labelText: LocaleKeys.refund_amount_label.tr(),
                ),
              ),
              12.verticalSpace,
              TextFormField(
                controller: _reason,
                maxLines: 4,
                maxLength: _maxReason,
                textInputAction: TextInputAction.newline,
                validator: _validateReason,
                decoration: InputDecoration(
                  labelText: LocaleKeys.refund_reason_label.tr(),
                  alignLabelWithHint: true,
                ),
              ),
              12.verticalSpace,
              AppButton(
                height: 44,
                label: LocaleKeys.refund_submit.tr(),
                onPressed: _submit,
              ),
              16.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
