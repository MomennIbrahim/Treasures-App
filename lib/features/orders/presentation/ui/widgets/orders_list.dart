import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_shimmer.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/orders/data/model/order_model.dart';
import 'package:konoz/features/orders/presentation/controllers/orders_cubit.dart';
import 'package:konoz/features/orders/presentation/ui/widgets/order_card.dart';
import 'package:konoz/generated/locale_keys.g.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OrdersList extends StatelessWidget {
  const OrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state.isFailure) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.failure?.getAllError() ??
                        LocaleKeys.errors_errors_unexpected.tr(),
                    style: AppTextStyles.text12Regular,
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () => context.read<OrdersCubit>().retry(),
                    child: Text(LocaleKeys.general_retry.tr()),
                  ),
                ],
              ),
            ),
          );
        }

        final isLoading = state.isLoading || state.isInitial;
        final orders = isLoading
            ? List.generate(3, (_) => OrderModel.empty())
            : state.visibleOrders;

        if (orders.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                state.query.trim().isEmpty
                    ? LocaleKeys.orders_empty.tr()
                    : LocaleKeys.general_search_no_results.tr(),
                style: AppTextStyles.text12Regular,
              ),
            ),
          );
        }

        return SliverPadding(
          padding: paddingAll(16),
          sliver: Skeletonizer.sliver(
            effect: AppShimmer.effect(context),
            enabled: isLoading,
            child: SliverList.separated(
              itemCount: orders.length,
              separatorBuilder: (_, _) => 12.verticalSpace,
              itemBuilder: (context, index) => OrderCard(order: orders[index]),
            ),
          ),
        );
      },
    );
  }
}
