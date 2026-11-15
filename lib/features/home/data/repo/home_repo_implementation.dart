import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:konoz/core/error/app_exception.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/core/networking/endpoints.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/home/data/model/banners_model.dart';
import 'package:konoz/features/home/data/model/best_selling_model.dart';
import 'package:konoz/features/home/data/model/currently_trending_model.dart';
import 'package:konoz/features/home/data/model/packages_model.dart';
import 'package:konoz/features/home/data/repo/home_repo.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class HomeRepoImplementation extends HomeRepo {
  final ApiService _apiService;

  HomeRepoImplementation(this._apiService);

  @override
  Future<Either<AppFailure, BannersModel>> getBanners() async {
    try {
      final res = await _apiService.getData(endPoint: EndPoint.banners);

      final banners = _listOf(
        res.data,
      ).map((json) => BannerData.fromJson(json)).toList();

      return Right(
        BannersModel(
          success: true,
          message: 'Banners fetched successfully',
          bannersData: banners,
        ),
      );
    } catch (e) {
      return Left(toFailure(e));
    }
  }

  @override
  Future<Either<AppFailure, BestSellingModel>> getBestSelling({
    int page = 1,
  }) async {
    try {
      // الـ API مفيهاش pagination، الترتيب بيتحدد من لوحة التحكم.
      final res = await _apiService.getData(endPoint: EndPoint.topSellers);

      final products = _productsOf(
        res.data,
      ).map((json) => ProductItemModel.fromApi(json)).toList();

      return Right(
        BestSellingModel(
          success: true,
          message: 'Best selling fetched successfully',
          products: products,
          pagination: null,
        ),
      );
    } catch (e) {
      return Left(toFailure(e));
    }
  }

  @override
  Future<Either<AppFailure, CurrentlyTrendingModel>> getCurrentlyTrending({
    int page = 1,
  }) async {
    try {
      final res = await _apiService.getData(endPoint: EndPoint.trending);

      final products = _productsOf(
        res.data,
      ).map((json) => ProductItemModel.fromApi(json)).toList();

      return Right(
        CurrentlyTrendingModel(
          success: true,
          message: 'Currently trending fetched successfully',
          products: products,
        ),
      );
    } catch (e) {
      return Left(toFailure(e));
    }
  }

  @override
  Future<Either<AppFailure, PackagesModel>> getPackages({int page = 1}) async {
    try {
      final res = await _apiService.getData(endPoint: EndPoint.packages);

      final packages = _listOf(
        res.data,
      ).map((json) => PackageItemModel.fromJson(json)).toList();

      return Right(
        PackagesModel(
          success: true,
          message: 'Packages fetched successfully',
          packages: packages,
        ),
      );
    } catch (e) {
      return Left(toFailure(e));
    }
  }


}
  // ───────────────────────────── Helpers ─────────────────────────────

  /// الرد بشكل { "data": [ ... ] }
  List<Map<String, dynamic>> _listOf(dynamic body) {
    final data = body is Map ? body['data'] : null;
    if (data is! List) return const [];
    return data.whereType<Map<String, dynamic>>().toList();
  }

  /// الرد بشكل { "data": { "id": ..., "name": ..., "products": [ ... ] } }
  List<Map<String, dynamic>> _productsOf(dynamic body) {
    final data = body is Map ? body['data'] : null;
    final products = data is Map ? data['products'] : null;
    if (products is! List) return const [];
    return products.whereType<Map<String, dynamic>>().toList();
  }

  AppFailure toFailure(Object error) {
    if (error is AppException) {
      return RemoteServerFailure(
        error.message.isNotEmpty
            ? error.message
            : LocaleKeys.errors_errors_unexpected.tr(),
      );
    }
    return RemoteServerFailure(error.toString());
  }