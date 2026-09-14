import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/home/data/model/banners_model.dart';
import 'package:konoz/features/home/data/model/best_selling_model.dart';
import 'package:konoz/features/home/data/model/currently_trending_model.dart';

abstract class HomeRepo {
  // Get Banners List
  Future<Either<AppFailure, BannersModel>> getBanners();

  // Get Best Selling List
  Future<Either<AppFailure, BestSellingModel>> getBestSelling({int page = 1});

  // Get Currently Trending List
  Future<Either<AppFailure, CurrentlyTrendingModel>> getCurrentlyTrending({
    int page = 1,
  });
}
