import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/orders/data/model/order_model.dart';
import 'package:konoz/features/orders/data/model/orders_filter.dart';

abstract class OrdersRepo {
  Future<Either<AppFailure, List<OrderModel>>> getOrders({
    required OrdersFilter filter,
  });
}
