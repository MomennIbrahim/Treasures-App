import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/collection_products/data/model/collection_products_model.dart';
 
abstract class CollectionProductsRepo {
  // Get Collection Products by Category (paginated)
  Future<Either<AppFailure, CollectionProductsModel>> getCollectionProducts({
    required int categoryId,
    int page = 1,
  });
}