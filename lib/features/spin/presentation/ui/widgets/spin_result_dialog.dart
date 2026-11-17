import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/features/spin/data/model/spin_result_model.dart';
import 'package:konoz/features/spin/data/model/spin_wheel_model.dart';
import 'package:konoz/generated/locale_keys.g.dart';

/// [prize] القطاع اللي العجلة وقفت عليه، و[result] رد السيرفر.
/// الرسالة بتاعت السيرفر هي الأساس، ولو فاضية بنرجع للنص المحلي.
Future<void> showSpinResultDialog(
  BuildContext context, {
  required SpinSection prize,
  required SpinResultModel result,
}) {
  final message = result.message.trim().isNotEmpty
      ? result.message
      : (prize.isTryAgain
            ? LocaleKeys.spin_better_luck.tr()
            : LocaleKeys.spin_you_won.tr(args: [prize.label]));

  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(
        LocaleKeys.spin_result_title.tr(),
        style: AppTextStyles.text16Bold,
      ),
      content: Text(message, style: AppTextStyles.text14Bold),
      actions: [
        AppButton(
          height: 35,
          onPressed: () => Navigator.of(ctx).pop(),
          label: LocaleKeys.spin_ok.tr(),
        ),
      ],
    ),
  );
}