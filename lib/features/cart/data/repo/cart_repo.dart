import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/cart/data/model/cart_item_model.dart';
import 'package:konoz/features/cart/data/model/cart_summary_model.dart';

abstract class CartRepo {
  Future<Either<AppFailure, Unit>> addToCart({
    required int sizeId,
    int quantity = 1,
  });

  /// عدد الأصناف في السلة (للـ badge)
  Future<Either<AppFailure, int>> getCartCount();

  Future<Either<AppFailure, List<CartItemModel>>> getCart();

  Future<Either<AppFailure, Unit>> updateQuantity({
    required int itemId,
    required int quantity,
  });

  Future<Either<AppFailure, Unit>> removeItem(int itemId);

  /// الأرقام محسوبة على السيرفر
  Future<Either<AppFailure, CartSummaryModel>> getSummary({String? coupon});
}
