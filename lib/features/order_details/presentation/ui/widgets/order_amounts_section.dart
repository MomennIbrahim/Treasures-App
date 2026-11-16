import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/order_details/data/model/order_details_model.dart';
import 'package:konoz/features/order_details/presentation/ui/widgets/order_details_card.dart';
import 'package:konoz/features/order_details/presentation/ui/widgets/order_details_helpers.dart';
 
import 'package:konoz/generated/locale_keys.g.dart';

class OrderAmountsSection extends StatelessWidget {
  final OrderAmounts amounts;
  const OrderAmountsSection({super.key, required this.amounts});

  Widget _row(String label, String value, {bool bold = false}) => Padding(
    padding: EdgeInsets.symmetric(vertical: 4.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: bold ? AppTextStyles.text16Bold : null),
        Text(
          value,
          style: bold
              ? AppTextStyles.text16Bold
              : const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return OrderDetailsCard(
      title: LocaleKeys.cart_summary_order.tr(),
      child: Column(
        children: [
          _row(LocaleKeys.cart_coast.tr(), orderMoney(amounts.subtotal)),
          _row(LocaleKeys.cart_shipping.tr(), orderMoney(amounts.shipping)),
          _row(LocaleKeys.cart_tax.tr(), orderMoney(amounts.tax)),
          if (amounts.discount > 0)
            _row(
              LocaleKeys.cart_discount.tr(),
              '- ${orderMoney(amounts.discount)}',
            ),
          const Divider(),
          _row(
            LocaleKeys.cart_total.tr(),
            orderMoney(amounts.total),
            bold: true,
          ),
        ],
      ),
    );
  }
}
