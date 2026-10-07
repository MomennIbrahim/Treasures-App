import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/supabase_db_service.dart';
import 'package:konoz/features/checkout/data/model/checkout_model.dart';
import 'package:konoz/features/checkout/data/repo/checkout_rpo.dart';
 

class CheckoutRepoImplementation implements CheckoutRepo {
  final SupabaseDbService _db;
  CheckoutRepoImplementation(this._db);

  @override
  Future<Either<AppFailure, PlacedOrderModel>> placeOrder({
    required int addressId,
    String paymentMethod = 'cod',
    String? coupon,
  }) async {
    try {
      final res = await _db.callRpc(
        function: 'place_order',
        params: {
          'p_address_id': addressId,
          'p_payment_method': paymentMethod,
          'p_coupon': coupon,
        },
      );
      final raw = res is List && res.isNotEmpty ? res.first : res;
      return Right(
        PlacedOrderModel.fromJson(Map<String, dynamic>.from(raw as Map)),
      );
    } catch (e) {
      return Left(RemoteServerFailure.from(e));
    }
  }
}