import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/collection_products/data/repo/collection_products_repo.dart';

part 'collection_products_state.dart';

class CollectionProductsCubit extends SafeCubit<CollectionProductsState> {
  final CollectionProductsRepo _repo;
  CollectionProductsCubit(this._repo) : super(const CollectionProductsState());

  final Map<int, List<ProductItemModel>> _cache = {};
  int _requestId = 0;

  /// id = 0 يعني All
  Future<void> selectCollection(int id, {bool force = false}) async {
    if (!force &&
        id == state.selectedCollectionId &&
        (state.isSuccess || state.isLoading)) {
      return;
    }

    final reqId = ++_requestId; // أي رد قديم يتجاهل

    final cached = _cache[id];
    if (!force && cached != null) {
      emit(
        state.copyWith(
          selectedCollectionId: id,
          status: CollectionProductsStatus.success,
          products: cached,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        selectedCollectionId: id,
        status: CollectionProductsStatus.loading,
        products: const [],
      ),
    );

    final res = await _repo.getCollectionProducts(
      collectionId: id == 0 ? null : id,
    );
    if (reqId != _requestId || isClosed) return;

    res.fold(
      (f) => emit(
        state.copyWith(status: CollectionProductsStatus.failure, failure: f),
      ),
      (list) {
        _cache[id] = list;
        emit(
          state.copyWith(
            status: CollectionProductsStatus.success,
            products: list,
          ),
        );
      },
    );
  }

  Future<void> retry() =>
      selectCollection(state.selectedCollectionId, force: true);
}