import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/core/widgets/show_blurred_confirmation_dialog.dart';
import 'package:konoz/features/order_details/presentation/controllers/order_details/order_details_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class OrderCancelButton extends StatelessWidget {
  const OrderCancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OrderDetailsCubit, OrderDetailsState, bool>(
      selector: (s) => s.isCancelling,
      builder: (context, busy) => Flexible(
        flex: 2,
        child: Align(
          alignment: AlignmentGeometry.topEnd,
          child: AppButton(
            height: 36,
            width: 100,
            label: LocaleKeys.orders_cancel_order.tr(),
            buttonColor: AppColors.error700.withAlpha(180),
            onPressed: busy
                ? null
                : () {
                    final cubit = context.read<OrderDetailsCubit>();
                    showBlurredConfirmationDialog(
                      context: context,
                      title: LocaleKeys.orders_cancel_order_title,
                      message: LocaleKeys.orders_cancel_order_body,
                      confirmText: LocaleKeys.orders_cancel_order_confirm.tr(),
                      secondaryText: LocaleKeys.orders_cancel_order_keep.tr(),
                      onConfirm: cubit.cancel,
                    );
                  },
          ),
        ),
      ),
    );
  }
}
