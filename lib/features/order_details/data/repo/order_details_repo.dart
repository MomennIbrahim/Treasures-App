import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/order_details/data/model/order_details_model.dart';

abstract class OrderDetailsRepo {
  Future<Either<AppFailure, OrderDetailsModel>> getOrderDetails(int orderId);
}
