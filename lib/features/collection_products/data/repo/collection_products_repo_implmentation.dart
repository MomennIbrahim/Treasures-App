import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/supabase_db_service.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/collection_products/data/model/collection_products_model.dart';
import 'package:konoz/features/collection_products/data/repo/collection_products_repo.dart';
import 'package:konoz/generated/locale_keys.g.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CollectionProductsRepoImplementation extends CollectionProductsRepo {
  final SupabaseDbService _supabaseDbService;

  CollectionProductsRepoImplementation(this._supabaseDbService);

  @override
  Future<Either<AppFailure, CollectionProductsModel>> getCollectionProducts({
    required String collectionId,
  }) async {
    try {
      final response = await _supabaseDbService.getCollection(
        path: "products",
        filters: [QueryFilter(field: 'collection_id', isEqualTo: collectionId)],
      );

      final collectionProducts = response
          .map((json) => ProductItemModel.fromJson(json))
          .toList();

      final packagesModel = CollectionProductsModel(
        success: true,
        message: 'Products fetched successfully',
        products: collectionProducts,
        pagination: null,
      );

      return Right(packagesModel);
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
