import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/supabase_db_service.dart';
import 'package:konoz/features/cart/data/model/cart_item_model.dart';
import 'package:konoz/features/cart/data/model/cart_summary_model.dart';
import 'package:konoz/features/cart/data/repo/cart_repo.dart';

class CartRepoImplementation implements CartRepo {
  final SupabaseDbService _db;
  CartRepoImplementation(this._db);

  @override
  Future<Either<AppFailure, Unit>> addToCart({
    required int sizeId,
    int quantity = 1,
  }) async {
    try {
      await _db.callRpc(
        function: 'add_to_cart',
        params: {'p_size_id': sizeId, 'p_quantity': quantity},
      );
      return const Right(unit);
    } catch (e) {
      return Left(RemoteServerFailure.from(e));
    }
  }

  @override
  Future<Either<AppFailure, int>> getCartCount() async {
    try {
      final rows = await _db.getCollection(path: 'cart_items', columns: 'id');
      return Right(rows.length);
    } catch (e) {
      return Left(RemoteServerFailure.from(e));
    }
  }

  @override
  Future<Either<AppFailure, List<CartItemModel>>> getCart() async {
    try {
      final rows = await _db.getCollection(
        path: 'cart_items',
        columns: '*, product_sizes(*, products(id, name, images))',
        orderByField: 'created_at',
      );
      final items = rows
          .map((r) => CartItemModel.fromJson(Map<String, dynamic>.from(r)))
          .toList();
      return Right(items);
    } catch (e) {
      return Left(RemoteServerFailure.from(e));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> updateQuantity({
    required int itemId,
    required int quantity,
  }) async {
    try {
      await _db.callRpc(
        function: 'update_cart_quantity',
        params: {'p_item_id': itemId, 'p_quantity': quantity},
      );
      return const Right(unit);
    } catch (e) {
      return Left(RemoteServerFailure.from(e));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> removeItem(int itemId) async {
    try {
      await _db.deleteDocument(path: 'cart_items', id: itemId.toString());
      return const Right(unit);
    } catch (e) {
      return Left(RemoteServerFailure.from(e));
    }
  }

  @override
  Future<Either<AppFailure, CartSummaryModel>> getSummary({
    String? coupon,
  }) async {
    try {
      final res = await _db.callRpc(
        function: 'get_cart_summary',
        params: {'p_coupon': coupon},
      );
      // الـ RPC بترجع jsonb. بنتحمل لو جت Map أو List فيها Map.
      final raw = res is List && res.isNotEmpty ? res.first : res;
      return Right(
        CartSummaryModel.fromJson(Map<String, dynamic>.from(raw as Map)),
      );
    } catch (e) {
      return Left(RemoteServerFailure.from(e));
    }
  }
}
