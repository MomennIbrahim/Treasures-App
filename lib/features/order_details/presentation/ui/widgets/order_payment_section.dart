import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/features/order_details/presentation/ui/widgets/order_details_card.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class OrderPaymentSection extends StatelessWidget {
  final bool isCash;
  const OrderPaymentSection({super.key, required this.isCash});

  @override
  Widget build(BuildContext context) {
    return OrderDetailsCard(
      title: LocaleKeys.checkout_payment_method.tr(),
      child: Row(
        children: [
          // Icon(isCash ? Icons.money_outlined : Icons.credit_card_outlined),
          HugeIcon(
            icon: isCash
                ? HugeIcons.strokeRoundedCash01
                : HugeIcons.strokeRoundedCreditCard,
            size: 18.sp,
            color: AppColors.success800,
          ),
          10.horizontalSpace,
          Text(
            isCash
                ? LocaleKeys.checkout_cash_on_delivery.tr()
                : LocaleKeys.checkout_credit_debit_card.tr(),
          ),
        ],
      ),
    );
  }
}
