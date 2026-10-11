import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/supabase_db_service.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/collection_products/data/repo/collection_products_repo.dart';

class CollectionProductsRepoImplementation implements CollectionProductsRepo {
  final SupabaseDbService _db;
  CollectionProductsRepoImplementation(this._db);

  @override
  Future<Either<AppFailure, List<ProductItemModel>>> getCollectionProducts({
    int? collectionId,
  }) async {
    try {
      final rows = await _db.getCollection(
        path: 'products',
        columns: '*, product_sizes(*)',
        filters: collectionId == null
            ? null
            : [QueryFilter(field: 'collection_id', isEqualTo: collectionId)],
        orderByField: 'id',
        descending: false,
      );
      return Right(rows.map(ProductItemModel.fromSupabase).toList());
    } catch (e) {
      return Left(RemoteServerFailure.from(e));
    }
  }
}
