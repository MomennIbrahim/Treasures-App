import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/helper/date_format_helper.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/order_details/data/model/refund_model.dart';
import 'package:konoz/features/order_details/presentation/ui/widgets/order_details_card.dart';
import 'package:konoz/features/order_details/presentation/ui/widgets/refund_status_ui.dart';
import 'package:konoz/generated/locale_keys.g.dart';

/// كارت طلبات الإرجاع جوه تفاصيل الأوردر (مش تاب ولا شاشة).
class OrderRefundSection extends StatelessWidget {
  final OrderRefundInfo refund;
  const OrderRefundSection({super.key, required this.refund});

  @override
  Widget build(BuildContext context) {
    return OrderDetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(LocaleKeys.refund_title.tr(), style: AppTextStyles.text14Bold),
          for (final r in refund.items) ...[
            12.verticalSpace,
            _RefundTile(refund: r),
          ],
        ],
      ),
    );
  }
}

class _RefundTile extends StatelessWidget {
  final RefundModel refund;
  const _RefundTile({required this.refund});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${refund.amount} L.E • ${DateFormatHelper.dayMonth(refund.createdAt)}',
                style: AppTextStyles.text12Bold,
              ),
            ),
            Container(
              padding: paddingSymmetric(10, 4),
              decoration: BoxDecoration(
                color: refund.status.color.withValues(alpha: 0.6),
                borderRadius: AppRadius.br20,
              ),
              child: Text(refund.status.label, style: AppTextStyles.text10Bold),
            ),
          ],
        ),
        4.verticalSpace,

        // المنتجات (لو الطلب منتجات) أو سطر "مبلغ على الأوردر"
        if (refund.scope == RefundScope.items && refund.lines.isNotEmpty)
          for (final l in refund.lines)
            Padding(
              padding: paddingSymmetric(0, 1),
              child: Text(
                '${l.quantity} × ${l.productName}'
                '${l.size.isEmpty ? '' : ' ${l.size}'} — ${l.amount} L.E',
                style: AppTextStyles.text12Regular,
              ),
            )
        else
          Text(
            LocaleKeys.refund_scope_order.tr(),
            style: AppTextStyles.text12Regular,
          ),

        4.verticalSpace,
        Text(refund.reason, style: AppTextStyles.text12Regular),
        if (refund.note.isNotEmpty) ...[
          4.verticalSpace,
          Text(
            '${LocaleKeys.refund_note_label.tr()}: ${refund.note}',
            style: AppTextStyles.text12Regular,
          ),
        ],
      ],
    );
  }
}