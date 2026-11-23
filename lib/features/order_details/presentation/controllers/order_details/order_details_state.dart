part of 'order_details_cubit.dart';

enum OrderDetailsStatus { initial, loading, success, failure }

enum OrderCancelStatus { idle, loading, success, failure }

enum OrderRefundStatus { idle, loading, success, failure }

class OrderDetailsState extends Equatable {
  final OrderDetailsStatus status;
  final AppFailure? failure;
  final OrderDetailsModel? order;

  final OrderCancelStatus cancelStatus;
  final AppFailure? cancelFailure;

  final OrderRefundStatus refundStatus;
  final AppFailure? refundFailure;

  const OrderDetailsState({
    this.status = OrderDetailsStatus.initial,
    this.failure,
    this.order,
    this.cancelStatus = OrderCancelStatus.idle,
    this.cancelFailure,
    this.refundStatus = OrderRefundStatus.idle,
    this.refundFailure,
  });

  bool get isLoading =>
      status == OrderDetailsStatus.loading ||
      status == OrderDetailsStatus.initial;
  bool get isFailure => status == OrderDetailsStatus.failure;
  bool get isCancelling => cancelStatus == OrderCancelStatus.loading;
  bool get isRefunding => refundStatus == OrderRefundStatus.loading;

  // الـ failures بتتصفّر عن قصد
  OrderDetailsState copyWith({
    OrderDetailsStatus? status,
    AppFailure? failure,
    OrderDetailsModel? order,
    OrderCancelStatus? cancelStatus,
    AppFailure? cancelFailure,
    OrderRefundStatus? refundStatus,
    AppFailure? refundFailure,
  }) => OrderDetailsState(
    status: status ?? this.status,
    failure: failure,
    order: order ?? this.order,
    cancelStatus: cancelStatus ?? this.cancelStatus,
    cancelFailure: cancelFailure,
    refundStatus: refundStatus ?? this.refundStatus,
    refundFailure: refundFailure,
  );

  @override
  List<Object?> get props => [
    status,
    failure,
    order,
    cancelStatus,
    cancelFailure,
    refundStatus,
    refundFailure,
  ];
}