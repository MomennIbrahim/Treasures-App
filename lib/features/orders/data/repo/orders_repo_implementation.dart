import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/core/networking/endpoints.dart';
// نفس الـ import اللي باقي الـ repos
import 'package:konoz/features/home/data/repo/home_repo_implementation.dart'
    show toFailure;
import 'package:konoz/features/orders/data/model/order_model.dart';
import 'package:konoz/features/orders/data/model/orders_filter.dart';
import 'package:konoz/features/orders/data/repo/orders_repo.dart';

class OrdersRepoImplementation implements OrdersRepo {
  final ApiService _api;
  OrdersRepoImplementation(this._api);

  @override
  Future<Either<AppFailure, List<OrderModel>>> getOrders({
    required OrdersFilter filter,
  }) async {
    try {
      final res = await _api.getData(
        endPoint: EndPoint.orders,
        query: {
          if (filter.apiValue != null) 'filter': filter.apiValue,
        },
      );

      final body = res.data;
      final rows = body is Map
          ? body['data']
          : body; // بيتحمل لو الرد قايمة مباشرة

      final orders = (rows is List ? rows : const [])
          .whereType<Map>()
          .map((e) => OrderModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      return Right(orders);
    } catch (e) {
      return Left(toFailure(e));
    }
  }
}