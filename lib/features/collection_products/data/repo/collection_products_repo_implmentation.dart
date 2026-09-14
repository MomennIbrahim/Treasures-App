import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/core/networking/endpoints.dart';
import 'package:konoz/features/collection_products/data/model/collection_products_model.dart';
import 'package:konoz/features/collection_products/data/repo/collection_products_repo.dart';

class CollectionProductsRepoImplementation extends CollectionProductsRepo {
  final ApiService _apiService;

  CollectionProductsRepoImplementation(this._apiService);

  @override
  Future<Either<AppFailure, CollectionProductsModel>> getCollectionProducts({
    required int categoryId,
    int page = 1,
  }) async {
    try {
      final response = await _apiService.getData(
        endPoint: EndPoints.collectionProducts,
        query: {'category_id': categoryId, 'page': page},
      );
      final model = CollectionProductsModel.fromJson(response);
      return Right(model);
    } on DioException catch (e) {
      return Left(RemoteServerFailure.fromDioError(e));
    } catch (e) {
      return Left(RemoteServerFailure(e.toString()));
    }
  }
}
