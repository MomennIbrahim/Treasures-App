import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/home/data/demo/demo_best_selling_data.dart';
import 'package:konoz/features/home/data/model/best_selling_model.dart';

part 'best_selling_state.dart';

class BestSellingCubit extends SafeCubit<BestSellingState> {
  //final HomeRepo _homeRepo;

  BestSellingCubit() : super(const BestSellingState());

  Future<void> getBestSelling({int page = 1}) async {
    if (page == 1) {
      emit(
        state.copyWith(status: BestSellingStatus.loading, clearFailure: true),
      );
    } else {
      emit(state.copyWith(status: BestSellingStatus.loadingMore));
    }

    // Temporary Demo Data
    await Future.delayed(const Duration(seconds: 2));

    emit(
      state.copyWith(
        status: BestSellingStatus.success,
        bestSelling: DemoBestSellingData.demo,
        clearFailure: true,
      ),
    );

    // =========================
    // Real API - Later
    // =========================

    // final result = await _homeRepo.getBestSelling(
    //   page: page,
    // );

    // result.fold(
    //   (failure) {
    //     emit(
    //       state.copyWith(
    //         status: BestSellingStatus.failure,
    //         failure: failure,
    //       ),
    //     );
    //   },
    //   (data) {
    //     emit(
    //       state.copyWith(
    //         status: BestSellingStatus.success,
    //         bestSelling: data,
    //         clearFailure: true,
    //       ),
    //     );
    //   },
    // );
  }
}
