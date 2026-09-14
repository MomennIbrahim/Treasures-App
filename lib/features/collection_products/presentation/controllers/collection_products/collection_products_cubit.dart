import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/shared_model.dart/pagination_model.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/collection_products/data/demo/demo_collection_products_data.dart';

part 'collection_products_state.dart';

class CollectionProductsCubit extends SafeCubit<CollectionProductsState> {
  CollectionProductsCubit() : super(const CollectionProductsState());

  Future<void> getCollectionProducts({required int categoryId}) async {
    emit(
      state.copyWith(
        status: CollectionProductsStatus.loading,
        selectedCategoryId: categoryId,
        products: [],
        pagination: null,
        clearFailure: true,
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    final demo = DemoCollectionProductsData.demo;

    emit(
      state.copyWith(
        status: CollectionProductsStatus.success,
        products: demo.products,
        pagination: demo.pagination,
        clearFailure: true,
      ),
    );
  }

  Future<void> loadMoreCollectionProducts() async {
    if (state.hasReachedMax ||
        state.isLoadingMore ||
        state.selectedCategoryId == null) {
      return;
    }

    emit(state.copyWith(status: CollectionProductsStatus.loadingMore));

    final nextPage = (state.pagination?.currentPage ?? 1) + 1;

    await Future.delayed(const Duration(seconds: 2));

    final demo = DemoCollectionProductsData.demo;

    emit(
      state.copyWith(
        status: CollectionProductsStatus.success,
        products: [...state.products, ...demo.products],
        pagination: PaginationModel(
          currentPage: nextPage,
          lastPage: demo.pagination.lastPage,
          perPage: demo.pagination.perPage,
          total: demo.pagination.total,
        ),
      ),
    );
  }
}
