import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/core/networking/endpoints.dart';
import 'package:konoz/core/pagination/paginated.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/collection_products/data/repo/collection_products_repo.dart';
import 'package:konoz/features/home/data/repo/home_repo_implementation.dart'
    show toFailure;

class CollectionProductsRepoImplementation implements CollectionProductsRepo {
  final ApiService _apiService;
  CollectionProductsRepoImplementation(this._apiService);

  /// حجم الصفحة. من غيره السيرفر بيرجّع كل المنتجات (`per_page: all`).
  /// للتجربة خليه 2 وتأكد إن `meta.per_page` و`last_page` اتغيروا.
  static const _pageSize = 10;

  @override
  Future<Either<AppFailure, Paginated<ProductItemModel>>>
  getCollectionProducts({String? collectionId, int page = 1}) async {
    try {
      final res = await _apiService.getData(
        endPoint: EndPoint.products,
        query: {
          'page': page,
          'per_page': _pageSize,
          'collection': ?collectionId,
        },
      );

      return Right(Paginated.fromBody(res.data, ProductItemModel.fromApi));
    } catch (e) {
      return Left(toFailure(e));
    }
  }
}
