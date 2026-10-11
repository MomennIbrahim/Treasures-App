import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';

abstract class CollectionProductsRepo {
  /// collectionId = null → كل المنتجات (تاب All)
  Future<Either<AppFailure, List<ProductItemModel>>> getCollectionProducts({
    int? collectionId,
  });
}