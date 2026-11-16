import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/checkout/data/model/checkout_model.dart';
 
abstract class CheckoutRepo {
  Future<Either<AppFailure, PlacedOrderModel>> placeOrder({
    required int addressId,
    String paymentMethod = 'cod',
    String? coupon,
  });
}