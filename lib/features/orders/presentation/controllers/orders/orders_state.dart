part of 'orders_cubit.dart';

enum OrdersStatus { initial, loading, success, failure }

class OrdersState extends Equatable {
  final OrdersStatus status;
  final AppFailure? failure;
  final OrdersFilter filter;
  final String query;
  final List<OrderModel> orders;

  const OrdersState({
    this.status = OrdersStatus.initial,
    this.failure,
    this.filter = OrdersFilter.last3Months,
    this.query = '',
    this.orders = const [],
  });

  bool get isInitial => status == OrdersStatus.initial;
  bool get isLoading => status == OrdersStatus.loading;
  bool get isFailure => status == OrdersStatus.failure;

  /// الأوردرات بعد السيرش
  List<OrderModel> get visibleOrders =>
      query.trim().isEmpty ? orders : orders.where((o) => o.matches(query)).toList();

  // failure بيتصفّر عن قصد
  OrdersState copyWith({
    OrdersStatus? status,
    AppFailure? failure,
    OrdersFilter? filter,
    String? query,
    List<OrderModel>? orders,
  }) => OrdersState(
    status: status ?? this.status,
    failure: failure,
    filter: filter ?? this.filter,
    query: query ?? this.query,
    orders: orders ?? this.orders,
  );

  @override
  List<Object?> get props => [status, failure, filter, query, orders];
}