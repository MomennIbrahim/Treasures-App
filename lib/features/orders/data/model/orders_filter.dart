enum OrdersFilter {
  last30Days,
  last3Months,
  thisYear;

  ({DateTime from, DateTime? to}) get range {
    final now = DateTime.now();
    switch (this) {
      case OrdersFilter.last30Days:
        return (from: now.subtract(const Duration(days: 30)), to: null);
      case OrdersFilter.last3Months:
        return (from: now.subtract(const Duration(days: 90)), to: null);
      case OrdersFilter.thisYear:
        return (from: DateTime(now.year), to: DateTime(now.year + 1));
    }
  }
}