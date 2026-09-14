import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/product_details/data/model/product_details_model.dart';

abstract class ProductDetailsRepo {
  Future<Either<AppFailure, ProductDetailsModel>> getProductDetails({
    required int productId,
  });
}
