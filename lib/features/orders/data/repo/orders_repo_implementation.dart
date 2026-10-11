import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/supabase_db_service.dart';
import 'package:konoz/features/orders/data/model/order_model.dart';
import 'package:konoz/features/orders/data/model/orders_filter.dart';
import 'package:konoz/features/orders/data/repo/orders_repo.dart';

class OrdersRepoImplementation implements OrdersRepo {
  final SupabaseDbService _db;
  OrdersRepoImplementation(this._db);

  @override
  Future<Either<AppFailure, List<OrderModel>>> getOrders({
    required OrdersFilter filter,
  }) async {
    try {
      final r = filter.range;
      // الـ RLS بتفلتر لصاحب الأوردر، ومفيش user_id بيتبعت من الـ client
      final rows = await _db.getCollection(
        path: 'orders',
        columns:
            'id, status, total, created_at, order_items(product_name, image, quantity)',
        filters: [
          QueryFilter(
            field: 'created_at',
            isGreaterThan: r.from.toUtc().toIso8601String(),
            isLessThan: r.to?.toUtc().toIso8601String(),
          ),
        ],
        orderByField: 'created_at',
        descending: true,
        limit: 100,
      );
      return Right(
        rows.map((e) => OrderModel.fromJson(Map<String, dynamic>.from(e))).toList(),
      );
    } catch (e) {
      return Left(RemoteServerFailure.from(e));
    }
  }
}