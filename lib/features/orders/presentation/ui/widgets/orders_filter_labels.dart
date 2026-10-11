import 'package:easy_localization/easy_localization.dart';
import 'package:konoz/features/orders/data/model/orders_filter.dart';
import 'package:konoz/generated/locale_keys.g.dart';

extension OrdersFilterLabels on OrdersFilter {
  String get label {
    switch (this) {
      case OrdersFilter.last30Days:
        return LocaleKeys.orders_filter_last_30_days.tr();
      case OrdersFilter.last3Months:
        return LocaleKeys.orders_filter_last_3_months.tr();
      case OrdersFilter.thisYear:
        return '${DateTime.now().year}';
    }
  }

  String get historyTitle {
    switch (this) {
      case OrdersFilter.last30Days:
        return LocaleKeys.orders_history_last_30_days.tr();
      case OrdersFilter.last3Months:
        return LocaleKeys.orders_history_last_3_months.tr();
      case OrdersFilter.thisYear:
        return LocaleKeys.orders_history_year.tr(
          args: ['${DateTime.now().year}'],
        );
    }
  }
}
