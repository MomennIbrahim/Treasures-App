import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/features/order_details/presentation/controllers/order_details/order_details_cubit.dart';
import 'package:konoz/features/order_details/presentation/ui/widgets/refund_request_sheet.dart';
import 'package:konoz/generated/locale_keys.g.dart';

/// زرار صغير (بيتحط في الـ bar جنب العنوان).
/// اللون برتقالي/كهرماني: إجراء عادي بعد التسليم، عكس الإلغاء الأحمر.
class OrderRefundButton extends StatelessWidget {
  const OrderRefundButton({super.key});

  Future<void> _open(BuildContext context) async {
    final cubit = context.read<OrderDetailsCubit>();
    final order = cubit.state.order;
    if (order == null) return;

    final data = await showRefundRequestSheet(
      context,
      refundable: order.refund.refundable,
      items: order.items,
    );
    if (data == null || cubit.isClosed) return;

    cubit.requestRefund(reason: data.reason, items: data.items);
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 2,
      child: BlocSelector<OrderDetailsCubit, OrderDetailsState, bool>(
        selector: (s) => s.isRefunding,
        builder: (context, busy) => Align(
          alignment: AlignmentGeometry.centerEnd,
          child: AppButton(
            height: 35,
            width: 120,
            onPressed: busy ? null : () => _open(context),
            label: LocaleKeys.refund_request.tr(),
          ),
        ),
      ),
    );
  }
}
