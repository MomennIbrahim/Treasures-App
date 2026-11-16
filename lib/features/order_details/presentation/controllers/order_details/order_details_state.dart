part of 'order_details_cubit.dart';

enum OrderDetailsStatus { initial, loading, success, failure }

class OrderDetailsState extends Equatable {
  final OrderDetailsStatus status;
  final AppFailure? failure;
  final OrderDetailsModel? order;

  const OrderDetailsState({
    this.status = OrderDetailsStatus.initial,
    this.failure,
    this.order,
  });

  bool get isLoading =>
      status == OrderDetailsStatus.loading ||
      status == OrderDetailsStatus.initial;
  bool get isFailure => status == OrderDetailsStatus.failure;

  // failure بيتصفّر عن قصد
  OrderDetailsState copyWith({
    OrderDetailsStatus? status,
    AppFailure? failure,
    OrderDetailsModel? order,
  }) => OrderDetailsState(
    status: status ?? this.status,
    failure: failure,
    order: order ?? this.order,
  );

  @override
  List<Object?> get props => [status, failure, order];
}
