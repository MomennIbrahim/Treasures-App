import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/checkout/presentation/ui/widgets/payment_method_item.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class PaymentMethodSection extends StatefulWidget {
  const PaymentMethodSection({super.key});

  @override
  State<PaymentMethodSection> createState() => _PaymentMethodSectionState();
}

class _PaymentMethodSectionState extends State<PaymentMethodSection> {
  int _selectedPayment = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.checkout_payment_method.tr(),
          style: AppTextStyles.text16Bold,
        ),
        10.verticalSpace,

        PaymentMethodItem(
          index: 0,
          selectedIndex: _selectedPayment,
          icon: Icons.money_outlined,
          title: LocaleKeys.checkout_cash_on_delivery,
          subtitle: LocaleKeys.checkout_pay_when_your_order_arrives,
          onTap: _onPaymentSelected,
        ),

        8.verticalSpace,

        PaymentMethodItem(
          index: 1,
          selectedIndex: _selectedPayment,
          icon: Icons.credit_card_outlined,
          title: LocaleKeys.checkout_credit_debit_card,
          subtitle: LocaleKeys.checkout_pay_securely_with_your_card,
          onTap: _onPaymentSelected,
        ),
      ],
    );
  }

  void _onPaymentSelected(int index) {
    setState(() {
      _selectedPayment = index;
    });
  }
}
