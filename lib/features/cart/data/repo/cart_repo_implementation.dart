import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart' show Response;
import 'package:konoz/core/error/app_exception.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/core/networking/endpoints.dart';
import 'package:konoz/features/cart/data/model/cart_model.dart';
import 'package:konoz/features/cart/data/repo/cart_repo.dart';

/// الـ Bearer token بيتضاف تلقائيًا من ApiService، فمفيش userId.
class CartRepoImplementation implements CartRepo {
  final ApiService _api;
  CartRepoImplementation(this._api);

  @override
  Future<Either<AppFailure, CartModel>> getCart() =>
      _run(() => _api.getData(endPoint: EndPoint.cart), refetchIfNeeded: false);

  @override
  Future<Either<AppFailure, CartModel>> addToCart({
    required String productId,
    required String size,
    int quantity = 1,
  }) => _run(
    () => _api.postData(
      endPoint: EndPoint.cart,
      data: {'product_id': productId, 'size': size, 'quantity': quantity},
    ),
  );

  @override
  Future<Either<AppFailure, CartModel>> updateQuantity({
    required int itemId,
    required int quantity,
  }) => _run(
    () => _api.patchData(
      endPoint: EndPoint.cartItem(itemId),
      data: {'quantity': quantity},
    ),
  );

  @override
  Future<Either<AppFailure, CartModel>> removeItem(int itemId) =>
      _run(() => _api.deleteData(endPoint: EndPoint.cartItem(itemId)));

  // ───────── helpers ─────────

  /// بينفّذ الطلب، ولو الرد مش فيه السلة (مثلًا DELETE رجّع فاضي)
  /// بيجيبها بـ GET عشان نرجّع دايمًا حالة السيرفر الحقيقية.
  Future<Either<AppFailure, CartModel>> _run(
    Future<dynamic> Function() call, {
    bool refetchIfNeeded = true,
  }) async {
    try {
      var body = _asMap(await call());
      if (refetchIfNeeded && (body == null || !CartModel.looksLikeCart(body))) {
        body = _asMap(await _api.getData(endPoint: EndPoint.cart));
      }
      return Right(CartModel.fromApi(body ?? const {}));
    } on AppException catch (e) {
      return Left(RemoteServerFailure(e.message));
    } catch (e) {
      return Left(RemoteServerFailure(e.toString()));
    }
  }

  /// بيقبل Response أو Map مباشرة (حسب ApiService بيرجّع إيه)
  Map<String, dynamic>? _asMap(dynamic res) {
    final data = res is Response ? res.data : res;
    return data is Map ? Map<String, dynamic>.from(data) : null;
  }
}
