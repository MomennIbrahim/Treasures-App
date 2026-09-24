import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/features/collections/data/model/collections_model.dart';
import 'package:konoz/features/collections/data/repo/collections_repo.dart';

class CollectionsRepoImplementation extends CollectionsRepo {
  final FirestoreService _firestoreService;

  CollectionsRepoImplementation(this._firestoreService);

  @override
  Future<Either<AppFailure, List<CollectionsModel>>> getCollections() async {
    try {
      final response = await _firestoreService.getCollection(
        path: "collections",
      );
      final collections = response
          .map((json) => CollectionsModel.fromJson(json))
          .toList();
          
      return Right(collections);
    } on DioException catch (e) {
      return Left(RemoteServerFailure.fromDioError(e));
    } catch (e) {
      return Left(RemoteServerFailure(e.toString()));
    }
  }
}
