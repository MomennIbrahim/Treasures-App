import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/features/order_details/data/model/refund_model.dart';
import 'package:konoz/generated/locale_keys.g.dart';

/// نص ولون حالة الإرجاع (بيتستخدم في الكارت وبادج القايمة)
extension RefundStatusUi on RefundStatus {
  String get label {
    switch (this) {
      case RefundStatus.requested:
        return LocaleKeys.refund_status_requested.tr();
      case RefundStatus.approved:
        return LocaleKeys.refund_status_approved.tr();
      case RefundStatus.rejected:
        return LocaleKeys.refund_status_rejected.tr();
      case RefundStatus.refunded:
        return LocaleKeys.refund_status_refunded.tr();
    }
  }

  Color get color {
    switch (this) {
      case RefundStatus.requested:
        return AppColors.warning900;
      case RefundStatus.approved:
        return AppColors.primary;
      case RefundStatus.rejected:
        return AppColors.error700;
      case RefundStatus.refunded:
        return AppColors.success800;
    }
  }
}