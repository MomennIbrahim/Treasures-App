import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/features/product_details/data/demo/demo_product_details_data.dart';
import 'package:konoz/features/product_details/data/model/product_details_model.dart';
import 'package:konoz/features/product_details/data/repo/product_details_repo.dart';

class ProductDetailsRepoImplementation implements ProductDetailsRepo {
  final ApiService _apiService;

  ProductDetailsRepoImplementation(this._apiService);

  @override
  Future<Either<AppFailure, ProductDetailsModel>> getProductDetails({
    required int productId,
  }) async {
    try {
      // ============================
      // Demo
      // ============================

      await Future.delayed(const Duration(seconds: 2));

      return const Right(DemoProductDetailsData.product);

      // ============================
      // Real API
      // ============================

      // final response = await _apiService.getData(
      //   endPoint: '${EndPoints.productDetails}/$productId',
      // );

      // final model = ProductDetailsModel.fromJson(response);

      // return Right(model);
    } on DioException catch (e) {
      return Left(RemoteServerFailure.fromDioError(e));
    } catch (e) {
      return Left(RemoteServerFailure(e.toString()));
    }
  }
}
