enum OrdersFilter {
  last30Days,
  last3Months,
  thisYear;

  /// القيمة اللي بتتبعت في ?filter= (null = الافتراضي عند السيرفر: آخر 3 شهور)
  String? get apiValue {
    switch (this) {
      case OrdersFilter.last30Days:
        return 'last_30_days';
      case OrdersFilter.last3Months:
        return null;
      case OrdersFilter.thisYear:
        return 'this_year';
    }
  }
}