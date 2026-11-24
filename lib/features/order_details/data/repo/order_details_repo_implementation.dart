import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/core/networking/endpoints.dart';
import 'package:konoz/features/home/data/repo/home_repo_implementation.dart';
import 'package:konoz/features/order_details/data/model/order_details_model.dart';
import 'package:konoz/features/order_details/data/model/refund_model.dart';
import 'package:konoz/features/order_details/data/repo/order_details_repo.dart';

class OrderDetailsRepoImplementation implements OrderDetailsRepo {
  final ApiService _apiService;

  OrderDetailsRepoImplementation(this._apiService);

  @override
  Future<Either<AppFailure, OrderDetailsModel>> getOrderDetails(
    int orderId,
  ) async {
    try {
      final res = await _apiService.getData(
        endPoint: EndPoint.orderDetails(orderId),
      );
      return Right(OrderDetailsModel.fromBody(res.data));
    } catch (e) {
      return Left(toFailure(e));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> submitReview({
    required String productId,
    required int rating,
    required String comment,
  }) async {
    try {
      await _apiService.postData(
        endPoint: EndPoint.productReviews(productId),
        data: {'rating': rating, 'review': comment, 'product_id': productId},
      );
      return const Right(unit);
    } catch (e) {
      return Left(toFailure(e));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> requestRefund({
    required int orderId,
    required String reason,
    required List<RefundItemSelection> items,
  }) async {
    try {
      await _apiService.postData(
        endPoint: EndPoint.orderRefunds(orderId),
        data: {
          'reason': reason,
          'items': items.map((e) => e.toJson()).toList(),
        },
      );
      return const Right(unit);
    } catch (e) {
      return Left(toFailure(e));
    }
  }
}