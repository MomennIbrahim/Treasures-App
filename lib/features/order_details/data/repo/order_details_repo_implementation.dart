import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/core/networking/endpoints.dart';
import 'package:konoz/features/home/data/repo/home_repo_implementation.dart';
import 'package:konoz/features/order_details/data/model/order_details_model.dart';
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
}
