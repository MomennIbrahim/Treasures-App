import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/home/data/model/best_selling_model.dart';
import 'package:konoz/features/home/data/repo/home_repo.dart';

part 'best_selling_state.dart';

class BestSellingCubit extends SafeCubit<BestSellingState> {
  final HomeRepo _homeRepo;

  BestSellingCubit(this._homeRepo) : super(const BestSellingState());

  Future<void> getBestSelling() async {
    final result = await _homeRepo.getBestSelling();

    result.fold(
      (failure) => emit(
        state.copyWith(status: BestSellingStatus.failure, failure: failure),
      ),
      (data) => emit(
        state.copyWith(status: BestSellingStatus.success, bestSelling: data),
      ),
    );
  }
}
