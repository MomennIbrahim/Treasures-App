import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/features/order_details/presentation/controllers/order_details/order_details_cubit.dart';
import 'package:konoz/features/order_details/presentation/ui/widgets/refund_request_sheet.dart';
import 'package:konoz/generated/locale_keys.g.dart';

/// زرار صغير (بيتحط في الـ bar جنب العنوان)
class OrderRefundButton extends StatelessWidget {
  const OrderRefundButton({super.key});

  Future<void> _open(BuildContext context) async {
    final cubit = context.read<OrderDetailsCubit>();
    final refundable = cubit.state.order?.refund.refundable ?? 0;

    final data = await showRefundRequestSheet(context, refundable: refundable);
    if (data == null || cubit.isClosed) return;

    cubit.requestRefund(amount: data.amount, reason: data.reason);
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      flex: 2,
      child: BlocSelector<OrderDetailsCubit, OrderDetailsState, bool>(
        selector: (s) => s.isRefunding,
        builder: (context, busy) => Align(
          alignment: AlignmentGeometry.topEnd,
          child: AppButton(
            width: 130,
            height: 35,
            onPressed: busy ? null : () => _open(context),
            label: LocaleKeys.refund_request.tr(),
          ),
        ),
      ),
    );
  }
}
