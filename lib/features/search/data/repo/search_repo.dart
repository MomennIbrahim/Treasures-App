import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';

abstract class SearchRepo {
  Future<Either<AppFailure, List<ProductItemModel>>> searchProducts(
    String query,
  );
  Future<Either<AppFailure, List<String>>> getTrending();
  Future<List<String>> getSuggestions(String query);
  Future<void> logSearch(String query);
}