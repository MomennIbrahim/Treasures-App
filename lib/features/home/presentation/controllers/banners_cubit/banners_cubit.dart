import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/home/data/demo/demo_banners_data.dart';
import 'package:konoz/features/home/data/model/banners_model.dart';

part 'banners_state.dart';

class BannersCubit extends SafeCubit<BannersState> {
  // final HomeRepo _homeRepo  ;
  BannersCubit() : super(BannersState());

  Future<void> getBanners() async {
    emit(state.copyWith(status: BannersStatus.loading));

    await Future.delayed(const Duration(seconds: 2));

    emit(
      state.copyWith(
        status: BannersStatus.success,
        banners: DemoBannersData.banners,
      ),
    );

    // ============================
    // Real API
    // ============================

    // final result = await _homeRepo.getBanners();

    // result.fold(
    //   (failure) => emit(HomeFailure(failure.getAllError())),
    //   (banners) => emit(HomeSuccess(banners: banners)),
    // );
  }
}
