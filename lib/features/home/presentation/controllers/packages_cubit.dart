import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/home/data/demo/demo_packages_data.dart';
import 'package:konoz/features/home/data/model/packages_model.dart';

part 'packages_state.dart';

class PackagesCubit extends SafeCubit<PackagesState> {
  PackagesCubit() : super(const PackagesState());

  Future<void> getPackages({int page = 1}) async {
    if (page == 1) {
      emit(state.copyWith(status: PackagesStatus.loading, clearFailure: true));
    } else {
      emit(state.copyWith(status: PackagesStatus.loadingMore));
    }

    await Future.delayed(const Duration(seconds: 2));

    emit(
      state.copyWith(
        status: PackagesStatus.success,
        packages: DemoPackagesData.demo,
        clearFailure: true,
      ),
    );
  }
}
