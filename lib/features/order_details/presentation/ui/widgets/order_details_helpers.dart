import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:konoz/features/orders/data/model/order_model.dart';
import 'package:konoz/generated/locale_keys.g.dart';

/// لو عندك formatMoney في core استخدمها بدل دي
String orderMoney(num n) =>
    '${n % 1 == 0 ? n.toInt() : n.toStringAsFixed(2)} EGP';

String orderStatusText(OrderStatus s) => switch (s) {
  OrderStatus.pending => LocaleKeys.orders_status_pending.tr(),
  OrderStatus.confirmed => LocaleKeys.orders_status_confirmed.tr(),
  OrderStatus.shipped => LocaleKeys.orders_status_shipped.tr(),
  OrderStatus.delivered => LocaleKeys.orders_status_delivered.tr(),
  OrderStatus.cancelled => LocaleKeys.orders_status_cancelled.tr(),
};

/// لو OrderCard عندك فيه ألوان للحالات استخدمها هنا بدل دي
Color orderStatusColor(OrderStatus s) => switch (s) {
  OrderStatus.pending => Colors.orange,
  OrderStatus.confirmed => Colors.blue,
  OrderStatus.shipped => Colors.indigo,
  OrderStatus.delivered => Colors.green,
  OrderStatus.cancelled => Colors.red,
};
