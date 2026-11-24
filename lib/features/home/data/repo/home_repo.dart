import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/pagination/paginated.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/home/data/model/banners_model.dart';
import 'package:konoz/features/home/data/model/packages_model.dart';

abstract class HomeRepo {
  // Get Banners List
  Future<Either<AppFailure, BannersModel>> getBanners();

  // Get Best Selling List (صفحات)
  Future<Either<AppFailure, Paginated<ProductItemModel>>> getBestSelling({
    int page = 1,
  });

  // Get Currently Trending List (صفحات)
  Future<Either<AppFailure, Paginated<ProductItemModel>>> getCurrentlyTrending({
    int page = 1,
  });

  // Get Packages List (صفحات)
  Future<Either<AppFailure, Paginated<PackageItemModel>>> getPackages({
    int page = 1,
  });
}