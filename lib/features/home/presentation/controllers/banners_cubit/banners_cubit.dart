import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/home/data/model/banners_model.dart';
import 'package:konoz/features/home/data/repo/home_repo.dart';

part 'banners_state.dart';

class BannersCubit extends SafeCubit<BannersState> {
  final HomeRepo _homeRepo;
  BannersCubit(this._homeRepo)
    : super(BannersState(status: BannersStatus.initial));

  Future<void> getBanners() async {
    emit(state.copyWith(status: BannersStatus.loading));

    final result = await _homeRepo.getBanners();

    result.fold(
      (failure) => emit(
        state.copyWith(status: BannersStatus.failure, failure: failure),
      ),
      (banners) => emit(
        state.copyWith(status: BannersStatus.success, banners: banners),
      ),
    );
  }
}