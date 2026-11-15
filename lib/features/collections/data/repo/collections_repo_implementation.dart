import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:konoz/core/error/app_exception.dart';
import 'package:konoz/core/error/app_failure.dart';
 import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/core/networking/endpoints.dart';
import 'package:konoz/features/collections/data/model/collections_model.dart';
import 'package:konoz/features/collections/data/repo/collections_repo.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class CollectionsRepoImplementation extends CollectionsRepo {
  final ApiService _apiService;

  CollectionsRepoImplementation(this._apiService);

  @override
  Future<Either<AppFailure, List<CollectionsModel>>> getCollections() async {
    try {
      final res = await _apiService.getData(endPoint: EndPoint.collections);

      final body = res.data;
      final data = body is Map ? body['data'] : null;
      final collections = data is List
          ? data
                .whereType<Map<String, dynamic>>()
                .map(CollectionsModel.fromJson)
                .toList()
          : <CollectionsModel>[];

      return Right(collections);
    } on AppException catch (e) {
      return Left(
        RemoteServerFailure(
          e.message.isNotEmpty
              ? e.message
              : LocaleKeys.errors_errors_unexpected.tr(),
        ),
      );
    } catch (e) {
      return Left(RemoteServerFailure(e.toString()));
    }
  }
}