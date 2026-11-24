import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/order_details/data/model/order_details_model.dart';
import 'package:konoz/features/order_details/data/model/refund_model.dart';

abstract class OrderDetailsRepo {
  Future<Either<AppFailure, OrderDetailsModel>> getOrderDetails(int orderId);

  Future<Either<AppFailure, Unit>> submitReview({
    required String productId,
    required int rating,
    required String comment,
  });

  /// POST /orders/{id}/refunds  { items: [{order_item_id, quantity}], reason }
  /// السيرفر بيحسب المبلغ (سعر الوحدة × الكمية).
  Future<Either<AppFailure, Unit>> requestRefund({
    required int orderId,
    required String reason,
    required List<RefundItemSelection> items,
  });
}