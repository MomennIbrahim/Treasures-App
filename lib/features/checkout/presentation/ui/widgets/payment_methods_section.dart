import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/checkout/data/model/checkout_model.dart';
import 'package:konoz/features/checkout/presentation/controllers/checkout/checkout_cubit.dart';
import 'package:konoz/features/checkout/presentation/ui/widgets/payment_method_item.dart';
import 'package:konoz/generated/locale_keys.g.dart';

/// طرق الدفع جاية من GET /checkout (المفتوحة حاليًا فقط).
class PaymentMethodSection extends StatelessWidget {
  const PaymentMethodSection({super.key});

  IconData _icon(PaymentMethodModel p) =>
      p.isCash ? Icons.money_outlined : Icons.credit_card_outlined;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      buildWhen: (p, c) =>
          p.data != c.data ||
          p.loadStatus != c.loadStatus ||
          p.selectedPaymentId != c.selectedPaymentId,
      builder: (context, state) {
        // لو الـ API فشل أو رجّع قايمة فاضية: نعرض الكاش كخيار افتراضي
        final payments = state.payments.isNotEmpty
            ? state.payments
            : const [
                PaymentMethodModel(
                  id: 'cod',
                  name: 'Cash on Delivery',
                  detail: 'Pay when your order arrives',
                ),
              ];

        final selectedIndex = payments
            .indexWhere((p) => p.id == state.paymentMethod)
            .clamp(0, payments.length - 1);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.checkout_payment_method.tr(),
              style: AppTextStyles.text16Bold,
            ),
            10.verticalSpace,
            for (var i = 0; i < payments.length; i++) ...[
              if (i > 0) 8.verticalSpace,
              PaymentMethodItem(
                index: i,
                selectedIndex: selectedIndex,
                icon: _icon(payments[i]),
                title: payments[i].name,
                subtitle: payments[i].detail,
                onTap: (_) =>
                    context.read<CheckoutCubit>().selectPayment(payments[i].id),
              ),
            ],
          ],
        );
      },
    );
  }
}
