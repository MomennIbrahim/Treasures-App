import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/supabase_db_service.dart';
import 'package:konoz/features/collections/data/model/collections_model.dart';
import 'package:konoz/features/collections/data/repo/collections_repo.dart';
import 'package:konoz/generated/locale_keys.g.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CollectionsRepoImplementation extends CollectionsRepo {
  final SupabaseDbService _supabaseDbService;

  CollectionsRepoImplementation(this._supabaseDbService);

  @override
  Future<Either<AppFailure, List<CollectionsModel>>> getCollections() async {
    try {
      final data = await _supabaseDbService.getCollection(path: 'collections');
      final collections = data
          .map((json) => CollectionsModel.fromJson(json))
          .toList();
      return Right(collections);
    } on PostgrestException catch (e) {
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
