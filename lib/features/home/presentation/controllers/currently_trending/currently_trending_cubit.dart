import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/home/data/model/currently_trending_model.dart';
import 'package:konoz/features/home/data/repo/home_repo.dart';

part 'currently_trending_state.dart';

class CurrentlyTrendingCubit extends SafeCubit<CurrentlyTrendingState> {
  final HomeRepo _homeRepo;
  CurrentlyTrendingCubit(this._homeRepo)
    : super(
        const CurrentlyTrendingState(status: CurrentlyTrendingStatus.initial),
      );

  Future<void> getCurrentlyTrending({int page = 1}) async {
    emit(state.copyWith(status: CurrentlyTrendingStatus.loading));
    final result = await _homeRepo.getCurrentlyTrending(page: page);
    
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CurrentlyTrendingStatus.failure,
          failure: failure,
        ),
      ),
      (currentlyTrendingModel) => emit(
        state.copyWith(
          status: CurrentlyTrendingStatus.success,
          currentlyTrending: currentlyTrendingModel,
        ),
      ),
    );
  }
}
