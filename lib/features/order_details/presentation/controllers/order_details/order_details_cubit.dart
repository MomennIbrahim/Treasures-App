import 'package:equatable/equatable.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/order_details/data/model/order_details_model.dart';
import 'package:konoz/features/order_details/data/model/refund_model.dart';
import 'package:konoz/features/order_details/data/repo/order_details_repo.dart';
import 'package:konoz/features/orders/data/repo/orders_repo.dart';

part 'order_details_state.dart';

class OrderDetailsCubit extends SafeCubit<OrderDetailsState> {
  final OrderDetailsRepo _repo;
  final OrdersRepo _ordersRepo;
  OrderDetailsCubit(this._repo, this._ordersRepo)
    : super(const OrderDetailsState());

  int _orderId = 0;

  /// silent = سحب للتحديث من غير skeleton
  Future<void> load(int orderId, {bool silent = false}) async {
    _orderId = orderId;
    emit(
      state.copyWith(
        status: silent && state.order != null
            ? OrderDetailsStatus.success
            : OrderDetailsStatus.loading,
      ),
    );

    final res = await _repo.getOrderDetails(orderId);
    if (isClosed) return;

    res.fold(
      (f) =>
          emit(state.copyWith(status: OrderDetailsStatus.failure, failure: f)),
      (o) => emit(state.copyWith(status: OrderDetailsStatus.success, order: o)),
    );
  }

  /// إلغاء الأوردر (قبل الشحن). بعد النجاح بنعيد التحميل من السيرفر.
  Future<void> cancel() async {
    final order = state.order;
    if (state.isCancelling || order == null || !order.canCancel) return;

    emit(state.copyWith(cancelStatus: OrderCancelStatus.loading));

    final res = await _ordersRepo.cancelOrder(order.id);
    if (isClosed) return;

    await res.fold(
      (f) async => emit(
        state.copyWith(
          cancelStatus: OrderCancelStatus.failure,
          cancelFailure: f,
        ),
      ),
      (_) async {
        emit(state.copyWith(cancelStatus: OrderCancelStatus.success));
        await load(order.id, silent: true);
      },
    );
  }

  /// طلب إرجاع بالمنتجات (بعد التسليم). بعد النجاح بنعيد التحميل
  /// عشان يظهر الكارت وتتحدث الكميات المتاحة.
  Future<void> requestRefund({
    required String reason,
    required List<RefundItemSelection> items,
  }) async {
    final order = state.order;
    if (state.isRefunding || order == null || !order.canRequestRefund) return;
    if (items.isEmpty) return;

    emit(state.copyWith(refundStatus: OrderRefundStatus.loading));

    final res = await _repo.requestRefund(
      orderId: order.id,
      reason: reason.trim(),
      items: items,
    );
    if (isClosed) return;

    await res.fold(
      (f) async => emit(
        state.copyWith(
          refundStatus: OrderRefundStatus.failure,
          refundFailure: f,
        ),
      ),
      (_) async {
        emit(state.copyWith(refundStatus: OrderRefundStatus.success));
        await load(order.id, silent: true);
      },
    );
  }

  Future<bool> submitReview(
    OrderDetailsItem item,
    int rating,
    String comment,
  ) async {
    if (item.productId.isEmpty) return false;

    final res = await _repo.submitReview(
      productId: item.productId,
      rating: rating,
      comment: comment,
    );

    return res.fold((failure) => false, (_) => true);
  }

  Future<void> retry() => load(_orderId);
}