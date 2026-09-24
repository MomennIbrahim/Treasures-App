import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/collections/data/model/collections_model.dart';
import 'package:konoz/features/collections/data/repo/collections_repo.dart';

part 'collections_state.dart';

class CollectionsCubit extends SafeCubit<CollectionsState> {
  final CollectionsRepo _collectionsRepo;
  CollectionsCubit(this._collectionsRepo) : super(const CollectionsState());

  Future<void> getCollections() async {
    
    emit(state.copyWith(status: CollectionsStatus.loading, clearFailure: true));

    final result = await _collectionsRepo.getCollections();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CollectionsStatus.failure,
          failure: failure,
          clearFailure: true,
        ),
      ),
      (collections) => emit(
        state.copyWith(
          status: CollectionsStatus.success,
          collections: collections,
          clearFailure: true,
        ),
      ),
    );
  }
}
