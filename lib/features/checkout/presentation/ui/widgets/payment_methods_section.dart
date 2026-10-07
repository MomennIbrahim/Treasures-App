import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/features/checkout/presentation/ui/widgets/payment_method_item.dart';
import 'package:konoz/generated/locale_keys.g.dart';

/// الدفع عند الاستلام فقط حاليًا. الكارت لما نربط بوابة دفع.
class PaymentMethodSection extends StatelessWidget {
  const PaymentMethodSection({super.key});

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
          selectedIndex: 0,
          icon: Icons.money_outlined,
          title: LocaleKeys.checkout_cash_on_delivery,
          subtitle: LocaleKeys.checkout_pay_when_your_order_arrives,
          onTap: (_) {},
        ),

        8.verticalSpace,

        Opacity(
          opacity: 0.5,
          child: PaymentMethodItem(
            index: 1,
            selectedIndex: 0,
            icon: Icons.credit_card_outlined,
            title: LocaleKeys.checkout_credit_debit_card,
            subtitle: LocaleKeys.checkout_pay_securely_with_your_card,
            onTap: (_) => AppToast.show(
              context,
              message: 'checkout.card_coming_soon'.tr(),
              type: AppToastType.warning,
            ),
          ),
        ),
      ],
    );
  }
}
