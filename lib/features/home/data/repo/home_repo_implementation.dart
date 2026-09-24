import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/home/data/model/banners_model.dart';
import 'package:konoz/features/home/data/model/best_selling_model.dart';
import 'package:konoz/features/home/data/model/currently_trending_model.dart';
import 'package:konoz/features/home/data/model/packages_model.dart';
import 'package:konoz/features/home/data/repo/home_repo.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class HomeRepoImplementation extends HomeRepo {
  final FirestoreService _firestoreService;

  HomeRepoImplementation(this._firestoreService);

  @override
  Future<Either<AppFailure, BannersModel>> getBanners() async {
    try {
      final data = await _firestoreService.getCollection(
        path: 'banners',
        filters: [const QueryFilter(field: 'active', isEqualTo: true)],
      );
      final banners = data.map((json) => BannerData.fromJson(json)).toList();
      final model = BannersModel(
        success: true,
        message: 'Banners fetched successfully',
        bannersData: banners,
      );
      return Right(model);
    } on FirebaseException catch (e) {
      return Left(
        RemoteServerFailure(
          e.message ?? LocaleKeys.errors_errors_unexpected.tr(),
        ),
      );
    } catch (e) {
      return Left(RemoteServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, BestSellingModel>> getBestSelling({
    int page = 1,
  }) async {
    try {
      final data = await _firestoreService.getCollection(
        path: 'products',
        filters: [const QueryFilter(field: 'is_best_seller', isEqualTo: true)],
        //  orderByField: 'createdAt',
        descending: true,
      );

      final products = data
          .map((json) => ProductItemModel.fromJson(json))
          .toList();

      final model = BestSellingModel(
        success: true,
        message: 'Best selling fetched successfully',
        products: products,
        pagination: null, // شرح تحت
      );

      return Right(model);
    } on FirebaseException catch (e) {
      return Left(
        RemoteServerFailure(
          e.message ?? LocaleKeys.errors_errors_unexpected.tr(),
        ),
      );
    } catch (e) {
      return Left(RemoteServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, CurrentlyTrendingModel>> getCurrentlyTrending({
    int page = 1,
  }) async {
    try {
      final data = await _firestoreService.getCollection(
        path: 'products',
        filters: [
          const QueryFilter(field: 'is_currently_trending', isEqualTo: true),
        ],
        //  orderByField: 'createdAt',
        descending: true,
      );

      final products = data
          .map((json) => ProductItemModel.fromJson(json))
          .toList();

      final model = CurrentlyTrendingModel(
        success: true,
        message: 'Currently trending fetched successfully',
        products: products,
      );

      return Right(model);
    } on FirebaseException catch (e) {
      return Left(
        RemoteServerFailure(
          e.message ?? LocaleKeys.errors_errors_unexpected.tr(),
        ),
      );
    } catch (e) {
      return Left(RemoteServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, PackagesModel>> getPackages({int page = 1}) async {
    try {
      final data = await _firestoreService.getCollection(
        path: 'packages',
        descending: true,
        filters: [
          const QueryFilter(field: 'is_available', isEqualTo: true),
        ],
      );

      final packages = data
          .map((json) => PackageItemModel.fromJson(json))
          .toList();

      final packagesModel = PackagesModel(
        success: true,
        message: 'Packeges fetched successfully',
        packages: packages,
      );

      return Right(packagesModel);
    } on FirebaseException catch (e) {
      return Left(
        RemoteServerFailure(
          e.message ?? LocaleKeys.errors_errors_unexpected.tr(),
        ),
      );
    } catch (e) {
      return Left(RemoteServerFailure(e.toString()));
    }
  }
}
