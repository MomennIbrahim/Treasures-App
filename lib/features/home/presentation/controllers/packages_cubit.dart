import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/home/data/model/packages_model.dart';
import 'package:konoz/features/home/data/repo/home_repo.dart';

part 'packages_state.dart';

class PackagesCubit extends SafeCubit<PackagesState> {
  final HomeRepo _homeRepo;
  PackagesCubit(this._homeRepo)
    : super(const PackagesState(status: PackagesStatus.initial));

  Future<void> getPackages({int page = 1}) async {
    emit(state.copyWith(status: PackagesStatus.loading));
    final result = await _homeRepo.getPackages(page: page);
    result.fold(
      (failure) => emit(
        state.copyWith(status: PackagesStatus.failure, failure: failure),
      ),
      (packages) => emit(
        state.copyWith(status: PackagesStatus.success, packages: packages,),
      ),
    );
  }
}
