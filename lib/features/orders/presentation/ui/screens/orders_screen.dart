import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/custom_back_icon.dart';
import 'package:konoz/features/orders/presentation/controllers/orders_cubit.dart';
import 'package:konoz/features/orders/presentation/ui/widgets/orders_filter_labels.dart';
import 'package:konoz/features/orders/presentation/ui/widgets/orders_list.dart';
import 'package:konoz/features/orders/presentation/ui/widgets/search_filter_on_orders.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<OrdersCubit>().getOrders(silent: true),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverPadding(
                padding: paddingAll(16),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      CustomBackIcon(),
                      16.horizontalSpace,
                      Text(
                        LocaleKeys.orders_title.tr(),
                        style: AppTextStyles.text18Bold,
                      ),
                    ],
                  ),
                ),
              ),
              const SearchFilterOnOrders(),
              const _HistoryTitle(),
              const OrdersList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryTitle extends StatelessWidget {
  const _HistoryTitle();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: paddingOnly(left: 16, right: 16, top: 16),
      sliver: SliverToBoxAdapter(
        child: BlocSelector<OrdersCubit, OrdersState, String>(
          selector: (s) => s.filter.historyTitle,
          builder: (context, title) =>
              Text(title, style: AppTextStyles.text16Bold),
        ),
      ),
    );
  }
}
