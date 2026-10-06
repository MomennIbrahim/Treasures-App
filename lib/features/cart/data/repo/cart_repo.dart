import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';

abstract class CartRepo {
  Future<Either<AppFailure, Unit>> addToCart({
    required int sizeId,
    int quantity = 1,
  });

  /// مجموع الكميات في السلة (للـ badge)
  Future<Either<AppFailure, int>> getCartCount();
}