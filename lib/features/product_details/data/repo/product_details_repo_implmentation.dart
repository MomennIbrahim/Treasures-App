import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/supabase_db_service.dart'; // عدّل المسار حسب مكان الملف
import 'package:konoz/features/product_details/data/model/product_details_model.dart';
import 'package:konoz/features/product_details/data/repo/product_details_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductDetailsRepoImplementation implements ProductDetailsRepo {
  final SupabaseDbService _dbService;
  ProductDetailsRepoImplementation(this._dbService);

  @override
  Future<Either<AppFailure, ProductDetailsModel>> getProductDetails({
    required int productId,
  }) async {
    try {
      final data = await _dbService.getDocument(
        path: 'products',
        id: productId,
      );

      if (data == null) return Left(RemoteServerFailure('Product not found'));

      final model = ProductDetailsModel.fromJson(data);

      return Right(model);
    } on PostgrestException catch (e) {
      return Left(RemoteServerFailure(e.message));
    } catch (e) {
      return Left(RemoteServerFailure(e.toString()));
    }
  }
}
