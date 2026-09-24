import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/collection_products/data/model/collection_products_model.dart';
import 'package:konoz/features/collection_products/data/repo/collection_products_repo.dart';

class CollectionProductsRepoImplementation extends CollectionProductsRepo {
  final FirestoreService _firestoreService;

  CollectionProductsRepoImplementation(this._firestoreService);

  @override
  Future<Either<AppFailure, CollectionProductsModel>> getCollectionProducts({
    required String collectionId,
    int page = 1,
  }) async {
    try {
      final response = await _firestoreService.getCollection(
        path: "products",
        filters: [QueryFilter(field: "collection_id", isEqualTo: collectionId)],
      );

      final collectionProducts = response
          .map((json) => ProductItemModel.fromJson(json))
          .toList();

      final packagesModel = CollectionProductsModel(
        success: true,
        message: 'Packeges fetched successfully',
        products: collectionProducts,
        pagination: null,
      );

      return Right(packagesModel);
    } on DioException catch (e) {
      return Left(RemoteServerFailure.fromDioError(e));
    } catch (e) {
      return Left(RemoteServerFailure(e.toString()));
    }
  }
}
