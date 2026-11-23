part of 'order_details_cubit.dart';

enum OrderDetailsStatus { initial, loading, success, failure }

enum OrderCancelStatus { idle, loading, success, failure }

class OrderDetailsState extends Equatable {
  final OrderDetailsStatus status;
  final AppFailure? failure;
  final OrderDetailsModel? order;

  final OrderCancelStatus cancelStatus;
  final AppFailure? cancelFailure;

  const OrderDetailsState({
    this.status = OrderDetailsStatus.initial,
    this.failure,
    this.order,
    this.cancelStatus = OrderCancelStatus.idle,
    this.cancelFailure,
  });

  bool get isLoading =>
      status == OrderDetailsStatus.loading ||
      status == OrderDetailsStatus.initial;
  bool get isFailure => status == OrderDetailsStatus.failure;
  bool get isCancelling => cancelStatus == OrderCancelStatus.loading;

  // failure و cancelFailure بيتصفّروا عن قصد
  OrderDetailsState copyWith({
    OrderDetailsStatus? status,
    AppFailure? failure,
    OrderDetailsModel? order,
    OrderCancelStatus? cancelStatus,
    AppFailure? cancelFailure,
  }) => OrderDetailsState(
    status: status ?? this.status,
    failure: failure,
    order: order ?? this.order,
    cancelStatus: cancelStatus ?? this.cancelStatus,
    cancelFailure: cancelFailure,
  );

  @override
  List<Object?> get props => [
    status,
    failure,
    order,
    cancelStatus,
    cancelFailure,
  ];
}