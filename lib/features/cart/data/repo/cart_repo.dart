import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/cart/data/model/cart_model.dart';

/// كل العمليات بترجّع السلة كاملة (items + العدد + الأرقام) من السيرفر،
/// فمفيش getSummary ولا getCartCount لوحدهم.
abstract class CartRepo {
  Future<Either<AppFailure, CartModel>> getCart();

  /// [size] هو الـ label زي ما السيرفر عايزه: "30 ml" | "50 ml" | "100 ml"
  Future<Either<AppFailure, CartModel>> addToCart({
    required String productId,
    required String size,
    int quantity = 1,
  });

  Future<Either<AppFailure, CartModel>> updateQuantity({
    required int itemId,
    required int quantity,
  });

  Future<Either<AppFailure, CartModel>> removeItem(int itemId);
}