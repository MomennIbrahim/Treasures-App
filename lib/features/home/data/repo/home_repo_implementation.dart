import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/core/networking/endpoints.dart';
import 'package:konoz/features/home/data/model/banners_model.dart';
import 'package:konoz/features/home/data/model/best_selling_model.dart';
import 'package:konoz/features/home/data/model/currently_trending_model.dart';
import 'package:konoz/features/home/data/repo/home_repo.dart';

class HomeRepoImplementation extends HomeRepo {
  final ApiService _apiService;

  HomeRepoImplementation(this._apiService);

  @override
  Future<Either<AppFailure, BannersModel>> getBanners() async {
    try {
      final response = await _apiService.getData(endPoint: EndPoints.banner);
      final model = BannersModel.fromJson(response);
      return Right(model);
    } on DioException catch (e) {
      return Left(RemoteServerFailure.fromDioError(e));
    } catch (e) {
      return Left(RemoteServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, BestSellingModel>> getBestSelling({
    int page = 1,
  }) async {
    try {
      final response = await _apiService.getData(
        endPoint: EndPoints.bestSelling,
      );
      final model = BestSellingModel.fromJson(response);
      return Right(model);
    } on DioException catch (e) {
      return Left(RemoteServerFailure.fromDioError(e));
    } catch (e) {
      return Left(RemoteServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, CurrentlyTrendingModel>> getCurrentlyTrending({
    int page = 1,
  }) async {
    try {
      final response = await _apiService.getData(
        endPoint: EndPoints.currentlyTrending,
      );
      final model = CurrentlyTrendingModel.fromJson(response);
      return Right(model);
    } on DioException catch (e) {
      return Left(RemoteServerFailure.fromDioError(e));
    } catch (e) {
      return Left(RemoteServerFailure(e.toString()));
    }
  }
}
