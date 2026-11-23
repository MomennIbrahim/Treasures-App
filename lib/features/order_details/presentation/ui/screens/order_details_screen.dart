import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/core/widgets/show_loading_dialog.dart';
import 'package:konoz/features/order_details/data/model/order_details_model.dart';
import 'package:konoz/features/order_details/presentation/controllers/order_details/order_details_cubit.dart';
import 'package:konoz/features/order_details/presentation/ui/widgets/order_address_section.dart';
import 'package:konoz/features/order_details/presentation/ui/widgets/order_amounts_section.dart';
import 'package:konoz/features/order_details/presentation/ui/widgets/order_details_bar.dart';
import 'package:konoz/features/order_details/presentation/ui/widgets/order_details_error_view.dart';
import 'package:konoz/features/order_details/presentation/ui/widgets/order_header_card.dart';
import 'package:konoz/features/order_details/presentation/ui/widgets/order_items_section.dart';
import 'package:konoz/features/order_details/presentation/ui/widgets/order_payment_section.dart';
import 'package:konoz/features/order_details/presentation/ui/widgets/order_tracking_section.dart';
import 'package:konoz/generated/locale_keys.g.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: BlocListener<OrderDetailsCubit, OrderDetailsState>(
          listenWhen: (p, c) => p.cancelStatus != c.cancelStatus,
          listener: (context, state) {
            switch (state.cancelStatus) {
              case OrderCancelStatus.loading:
                showLoadingDialog(context);
              case OrderCancelStatus.success:
                hideLoadingDialog(context);
                AppToast.show(
                  context,
                  message: LocaleKeys.orders_cancelled_success.tr(),
                );
              case OrderCancelStatus.failure:
                hideLoadingDialog(context);
                AppToast.show(
                  context,
                  message:
                      state.cancelFailure?.message ??
                      LocaleKeys.errors_errors_unexpected.tr(),
                  type: AppToastType.error,
                );
              case OrderCancelStatus.idle:
                break;
            }
          },
          child: BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
            builder: (context, state) {
              if (state.isFailure && state.order == null) {
                return OrderDetailsErrorView(
                  message: state.failure?.message ?? '',
                  onRetry: () => context.read<OrderDetailsCubit>().retry(),
                );
              }

              final loading = state.isLoading && state.order == null;
              final order = state.order ?? OrderDetailsModel.empty();

              return RefreshIndicator(
                onRefresh: () => context.read<OrderDetailsCubit>().load(
                  order.id,
                  silent: true,
                ),
                child: Skeletonizer(
                  enabled: loading,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: paddingAll(16),
                    children: [
                      OrderDetailsBar(
                        canCancel: order.canCancel,
                        loading: loading,
                      ),
                      16.verticalSpace,
                      OrderHeaderCard(order: order),
                      16.verticalSpace,
                      OrderTrackingSection(steps: order.tracking),
                      16.verticalSpace,
                      OrderItemsSection(
                        items: order.items,
                        onSubmitReview: loading
                            ? null
                            : (item, rating, comment) => context
                                  .read<OrderDetailsCubit>()
                                  .submitReview(item, rating, comment),
                      ),
                      if (!order.address.isEmpty) ...[
                        16.verticalSpace,
                        OrderAddressSection(address: order.address),
                      ],
                      16.verticalSpace,
                      OrderPaymentSection(isCash: order.isCash),
                      16.verticalSpace,
                      OrderAmountsSection(amounts: order.amounts),

                      24.verticalSpace,
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
