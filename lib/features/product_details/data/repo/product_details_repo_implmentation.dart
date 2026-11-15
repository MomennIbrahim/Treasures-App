import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/core/networking/endpoints.dart';
import 'package:konoz/features/home/data/repo/home_repo_implementation.dart';
import 'package:konoz/features/product_details/data/model/product_details_model.dart';
import 'package:konoz/features/product_details/data/repo/product_details_repo.dart';

class ProductDetailsRepoImplementation implements ProductDetailsRepo {
  final ApiService _apiService;
  ProductDetailsRepoImplementation(this._apiService);

  @override
  Future<Either<AppFailure, ProductDetailsModel>> getProductDetails({
    required String productId,
  }) async {
    try {
      final data = await _apiService.getData(
        endPoint: EndPoint.productDetails(productId.toString()),
      );

      final model = ProductDetailsModel.fromJson(data.data);

      return Right(model);
    } catch (e) {
      return Left(toFailure(e));
    }
  }
}
