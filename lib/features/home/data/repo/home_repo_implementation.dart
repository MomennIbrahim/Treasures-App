import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:konoz/core/error/app_exception.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/core/networking/endpoints.dart';
import 'package:konoz/core/pagination/paginated.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/home/data/model/banners_model.dart';
import 'package:konoz/features/home/data/model/packages_model.dart';
import 'package:konoz/features/home/data/repo/home_repo.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class HomeRepoImplementation extends HomeRepo {
  final ApiService _apiService;

  HomeRepoImplementation(this._apiService);

  /// حجم الصفحة. من غيره السيرفر بيرجّع الكل (`per_page: all`).
  static const _pageSize = 10;

  Map<String, dynamic> _pageQuery(int page) => {
    'page': page,
    'per_page': _pageSize,
  };

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

  /// الرد: { data: { id, name, products: [...] }, meta }
  @override
  Future<Either<AppFailure, Paginated<ProductItemModel>>> getBestSelling({
    int page = 1,
  }) async {
    try {
      final res = await _apiService.getData(
        endPoint: EndPoint.topSellers,
        query: _pageQuery(page),
      );

      return Right(
        Paginated.fromBody(
          res.data,
          ProductItemModel.fromApi,
          itemsKey: 'products',
        ),
      );
    } catch (e) {
      return Left(toFailure(e));
    }
  }

  @override
  Future<Either<AppFailure, Paginated<ProductItemModel>>> getCurrentlyTrending({
    int page = 1,
  }) async {
    try {
      final res = await _apiService.getData(
        endPoint: EndPoint.trending,
        query: _pageQuery(page),
      );

      return Right(
        Paginated.fromBody(
          res.data,
          ProductItemModel.fromApi,
          itemsKey: 'products',
        ),
      );
    } catch (e) {
      return Left(toFailure(e));
    }
  }

  @override
  Future<Either<AppFailure, Paginated<PackageItemModel>>> getPackages({
    int page = 1,
  }) async {
    try {
      final res = await _apiService.getData(
        endPoint: EndPoint.packages,
        query: _pageQuery(page),
      );

      return Right(Paginated.fromBody(res.data, PackageItemModel.fromJson));
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

/// بتتستخدم في باقي الـ repos كمان (import ... show toFailure)
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