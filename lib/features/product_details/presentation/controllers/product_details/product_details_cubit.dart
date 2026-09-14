import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/product_details/data/model/product_details_model.dart';
import 'package:konoz/features/product_details/data/repo/product_details_repo.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends SafeCubit<ProductDetailsState> {
  final ProductDetailsRepo _productDetailsRepo;

  ProductDetailsCubit(this._productDetailsRepo)
    : super(const ProductDetailsState());

  Future<void> getProductDetails({required int productId}) async {
    emit(state.copyWith(status: ProductDetailsStatus.loading, failure: null));

    final result = await _productDetailsRepo.getProductDetails(
      productId: productId,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ProductDetailsStatus.failure,
            failure: failure,
          ),
        );
      },
      (product) {
        emit(
          state.copyWith(
            status: ProductDetailsStatus.success,
            product: product,
            selectedSize: product.sizes.isNotEmpty ? product.sizes.first : null,
          ),
        );
      },
    );
  }

  void selectSize(ProductSizeModel size) {
    emit(state.copyWith(selectedSize: size));
  }
}
