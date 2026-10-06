import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/supabase_db_service.dart';
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
      final rows = await _db.getCollection(
        path: 'cart_items',
        columns: 'quantity',
      );
      final count = rows.fold<int>(
        0,
        (sum, r) => sum + (int.tryParse(r['quantity'].toString()) ?? 0),
      );
      return Right(count);
    } catch (e) {
      
      return Left(RemoteServerFailure.from(e));
    }
  }
}