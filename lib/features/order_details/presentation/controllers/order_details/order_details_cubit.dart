import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/order_details/data/model/order_details_model.dart';
import 'package:konoz/features/order_details/data/repo/order_details_repo.dart';

part 'order_details_state.dart';

class OrderDetailsCubit extends SafeCubit<OrderDetailsState> {
  final OrderDetailsRepo _repo;
  OrderDetailsCubit(this._repo) : super(const OrderDetailsState());

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

  Future<bool> submitReview(
    OrderDetailsItem item,
    int rating,
    String comment,
  ) async {
    debugPrint('SUBMIT REVIEW CUBIT CALLED');
    debugPrint('Product ID: ${item.productId}');
    debugPrint('Rating: $rating');
    debugPrint('Comment: $comment');
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
