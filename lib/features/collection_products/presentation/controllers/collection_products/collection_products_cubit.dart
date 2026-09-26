import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/shared_model.dart/pagination_model.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/collection_products/data/repo/collection_products_repo.dart';

part 'collection_products_state.dart';

class CollectionProductsCubit extends SafeCubit<CollectionProductsState> {
  final CollectionProductsRepo _collectionProductsRepo;
  CollectionProductsCubit(this._collectionProductsRepo)
    : super(
        const CollectionProductsState(status: CollectionProductsStatus.initial),
      );

  Future<void> getCollectionProducts({required int collectionId}) async {
    emit(state.copyWith(status: CollectionProductsStatus.loading));
    final failureOrCollectionProducts = await _collectionProductsRepo
        .getCollectionProducts(collectionId: collectionId);
    failureOrCollectionProducts.fold(
      (failure) {
        emit(
          state.copyWith(
            status: CollectionProductsStatus.failure,
            failure: failure,
          ),
        );
      },
      (collectionProducts) {
        emit(
          state.copyWith(
            status: CollectionProductsStatus.success,
            products: collectionProducts.products,
            pagination: collectionProducts.pagination,
          ),
        );
      },
    );
  }

  // Future<void> loadMoreCollectionProducts() async {
  //   if (state.hasReachedMax ||
  //       state.isLoadingMore ||
  //       state.selectedCategoryId == null) {
  //     return;
  //   }

  //   emit(state.copyWith(status: CollectionProductsStatus.loadingMore));

  //   final nextPage = (state.pagination?.currentPage ?? 1) + 1;

  //   await Future.delayed(const Duration(seconds: 2));

  //   final demo = DemoCollectionProductsData.demo;

  //   emit(
  //     state.copyWith(
  //       status: CollectionProductsStatus.success,
  //       products: [...state.products, ...demo.products],
  //       pagination: PaginationModel(
  //         currentPage: nextPage,
  //         lastPage: demo.pagination.lastPage,
  //         perPage: demo.pagination.perPage,
  //         total: demo.pagination.total,
  //       ),
  //     ),
  //   );
  // }
}
