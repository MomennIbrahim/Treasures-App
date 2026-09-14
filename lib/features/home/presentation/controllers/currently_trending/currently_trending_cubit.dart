import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/home/data/demo/demo_currently_trending_model.dart';
 import 'package:konoz/features/home/data/model/currently_trending_model.dart';

part 'currently_trending_state.dart';

class CurrentlyTrendingCubit extends SafeCubit<CurrentlyTrendingState> {
  CurrentlyTrendingCubit() : super(const CurrentlyTrendingState());

  Future<void> getCurrentlyTrending({int page = 1}) async {
    if (page == 1) {
      emit(
        state.copyWith(
          status: CurrentlyTrendingStatus.loading,
          clearFailure: true,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: CurrentlyTrendingStatus.loadingMore,
        ),
      );
    }

    await Future.delayed(const Duration(seconds: 2));

    emit(
      state.copyWith(
        status: CurrentlyTrendingStatus.success,
        currentlyTrending: DemoCurrentlyTrendingData.demo,
        clearFailure: true,
      ),
    );
  }
}