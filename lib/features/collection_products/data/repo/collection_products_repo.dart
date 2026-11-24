import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/pagination/paginated.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';

abstract class CollectionProductsRepo {
  /// collectionId = null → كل المنتجات (تاب All)
  /// page: رقم الصفحة (يبدأ من 1)
  Future<Either<AppFailure, Paginated<ProductItemModel>>>
  getCollectionProducts({String? collectionId, int page = 1});
}