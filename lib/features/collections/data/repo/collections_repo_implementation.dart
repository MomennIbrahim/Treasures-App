import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/core/networking/endpoints.dart';
import 'package:konoz/features/collections/data/model/collections_model.dart';
import 'package:konoz/features/collections/data/repo/collections_repo.dart';

class CollectionsRepoImplementation extends CollectionsRepo {
  final ApiService _apiService;

  CollectionsRepoImplementation(this._apiService);

  @override
  Future<Either<AppFailure, CollectionsModel>> getCollections() async {
    try {
      final response = await _apiService.getData(
        endPoint: EndPoints.collections,
      );
      final model = CollectionsModel.fromJson(response);
      return Right(model);
    } on DioException catch (e) {
      return Left(RemoteServerFailure.fromDioError(e));
    } catch (e) {
      return Left(RemoteServerFailure(e.toString()));
    }
  }
}
