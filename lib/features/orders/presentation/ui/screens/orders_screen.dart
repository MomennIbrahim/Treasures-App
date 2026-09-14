import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/custom_back_icon.dart';
import 'package:konoz/features/orders/presentation/ui/widgets/orders_list.dart';
import 'package:konoz/features/orders/presentation/ui/widgets/search_filter_on_orders.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: paddingAll(16),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    CustomBackIcon(),
                    16.horizontalSpace,
                    Text("Your Orders", style: AppTextStyles.text18Bold),
                  ],
                ),
              ),
            ),

            SearchFilterOnOrders(
              onFilterSelected: (filter) {
                log(filter);
              },
            ),
            SliverPadding(
              padding: paddingOnly(left: 16, right: 16, top: 16),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "History last 3month ",
                  style: AppTextStyles.text16Bold,
                ),
              ),
            ),
            OrdersList(),
          ],
        ),
      ),
    );
  }
}
