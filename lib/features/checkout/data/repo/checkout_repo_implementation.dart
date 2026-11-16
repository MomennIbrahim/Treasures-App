// checkout_repo_implementation.dart
import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/core/networking/endpoints.dart';
// نفس الـ import اللي بتستخدمه باقي الـ repos لـ toFailure
import 'package:konoz/features/home/data/repo/home_repo_implementation.dart'
    show toFailure;
import 'package:konoz/features/checkout/data/model/checkout_model.dart';
import 'package:konoz/features/checkout/data/repo/checkout_repo.dart';

class CheckoutRepoImplementation implements CheckoutRepo {
  final ApiService _api;
  CheckoutRepoImplementation(this._api);

  @override
  Future<Either<AppFailure, CheckoutModel>> getCheckout() async {
    try {
      final res = await _api.getData(endPoint: EndPoint.checkout);
      return Right(CheckoutModel.fromBody(res.data));
    } catch (e) {
      return Left(toFailure(e));
    }
  }

  @override
  Future<Either<AppFailure, PlacedOrderModel>> placeOrder({
    required int addressId,
    String paymentMethod = 'cod',
    String? coupon,
  }) async {
    try {
      final code = coupon?.trim();
      final res = await _api.postData(
        endPoint: EndPoint.orders,
        data: {
          'address_id': addressId,
          'payment_method': paymentMethod,
          if (code != null && code.isNotEmpty) 'coupon': code,
        },
      );
      return Right(PlacedOrderModel.fromBody(res.data));
    } catch (e) {
      return Left(toFailure(e));
    }
  }
}