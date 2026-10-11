import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';
import 'package:konoz/features/orders/data/model/order_model.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  const OrderCard({super.key, required this.order});

  String get _statusText {
    switch (order.status) {
      case OrderStatus.pending:
        return LocaleKeys.orders_status_pending.tr();
      case OrderStatus.confirmed:
        return LocaleKeys.orders_status_confirmed.tr();
      case OrderStatus.shipped:
        return LocaleKeys.orders_status_shipped.tr();
      case OrderStatus.delivered:
        return LocaleKeys.orders_status_delivered.tr();
      case OrderStatus.cancelled:
        return LocaleKeys.orders_status_cancelled.tr();
    }
  }

  Color get _statusColor {
    switch (order.status) {
      case OrderStatus.delivered:
        return AppColors.success800;
      case OrderStatus.cancelled:
        return AppColors.error700;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final extra = order.items.length - 1;
    final name = order.items.isEmpty
        ? LocaleKeys.orders_order_number.tr(args: ['${order.id}'])
        : order.items.first.name;

    final imageRadius = AppRadius.only(
      topLeft: const Radius.circular(8),
      bottomLeft: const Radius.circular(8),
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.onSurfaceVariant.withAlpha(20)),
        borderRadius: AppRadius.br8,
      ),
      child: Row(
        children: [
          if (order.image.isEmpty)
            Container(
              width: 100,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: imageRadius,
              ),
              child: Icon(Icons.shopping_bag_outlined, size: 28.sp),
            )
          else
            AppImage.cachedNetwork(
              order.image,
              borderRadius: imageRadius,
              width: 100,
              height: 110,
            ),
          Expanded(
            child: Padding(
              padding: paddingAll(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.text14Bold,
                        ),
                      ),
                      if (extra > 0) ...[
                        4.horizontalSpace,
                        Text(
                          LocaleKeys.orders_more_items.tr(args: ['$extra']),
                          style: AppTextStyles.text10Regular,
                        ),
                      ],
                    ],
                  ),
                  4.verticalSpace,
                  Text(
                    _statusText,
                    style: AppTextStyles.text12Bold.copyWith(color: _statusColor),
                  ),
                  4.verticalSpace,
                  Text(
                    '#${order.id} • ${order.dateLabel}',
                    style: AppTextStyles.text10Regular,
                  ),
                  4.verticalSpace,
                  Text(
                    '${order.totalLabel} L.E',
                    style: AppTextStyles.text12Bold,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}