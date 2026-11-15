import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/core/networking/endpoints.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/collection_products/data/repo/collection_products_repo.dart';

class CollectionProductsRepoImplementation implements CollectionProductsRepo {
  final ApiService _apiService;
  CollectionProductsRepoImplementation(this._apiService);

  @override
  Future<Either<AppFailure, List<ProductItemModel>>> getCollectionProducts({
    String? collectionId,
  }) async {
    try {
      final res = await _apiService.getData(
        endPoint: EndPoint.products,
        query: collectionId == null ? null : {'collection': collectionId},
      );

      final body = res.data;
      final data = body is Map ? body['data'] : null;
      final products = data is List
          ? data
                .whereType<Map<String, dynamic>>()
                .map(ProductItemModel.fromApi)
                .toList()
          : <ProductItemModel>[];

      return Right(products);
    } catch (e) {
      return Left(RemoteServerFailure(e.toString()));
    }
  }
}
