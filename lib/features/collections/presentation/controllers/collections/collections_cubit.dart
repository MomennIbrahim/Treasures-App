import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/collections/data/demo/collections_demo_data.dart';
import 'package:konoz/features/collections/data/model/collections_model.dart';

part 'collections_state.dart';

class CollectionsCubit extends SafeCubit<CollectionsState> {
  CollectionsCubit() : super(const CollectionsState());

  Future<void> getCollections() async {
    emit(state.copyWith(status: CollectionsStatus.loading, clearFailure: true));

    await Future.delayed(const Duration(seconds: 2));

    emit(
      state.copyWith(
        status: CollectionsStatus.success,
        collections: DemoCollectionsData.collections,
        clearFailure: true,
      ),
    );
  }
}
