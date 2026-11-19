import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/helper/date_format_helper.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/order_details/data/model/order_details_model.dart';
import 'package:konoz/features/order_details/presentation/controllers/order_details/order_details_cubit.dart';
import 'package:konoz/features/order_details/presentation/ui/widgets/order_details_card.dart';
import 'package:konoz/features/order_details/presentation/ui/widgets/order_details_helpers.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class OrderHeaderCard extends StatelessWidget {
  final OrderDetailsModel order;
  const OrderHeaderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final color = orderStatusColor(order.status);
    final isLoading = context.watch<OrderDetailsCubit>().state.isLoading;
    return OrderDetailsCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${LocaleKeys.order_details_order_date.tr()}: ${DateFormatHelper.dayMonth(order.createdAt)}",
                ),
                4.verticalSpace,
                Text(
                  LocaleKeys.orders_order_number.tr(args: ['${order.id}']),
                  style: AppTextStyles.text14Bold,
                ),
              ],
            ),
          ),
          Container(
            padding: paddingSymmetric(12, 6),
            decoration: BoxDecoration(
              color: isLoading
                  ? AppColors.neutral500.withValues(alpha: 0.2)
                  : color.withValues(alpha: 0.6),
              borderRadius: AppRadius.br20,
            ),
            child: Text(
              orderStatusText(order.status),
              style: AppTextStyles.text12Bold,
            ),
          ),
        ],
      ),
    );
  }
}
