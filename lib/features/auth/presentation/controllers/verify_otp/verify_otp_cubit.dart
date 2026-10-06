import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/auth/data/model/user_model.dart';
import 'package:konoz/features/auth/data/repo/auth_repo.dart';

part 'verify_otp_state.dart';

class VerifyOtpCubit extends SafeCubit<VerifyOtpState> {
  final AuthRepo authRepo;
  VerifyOtpCubit(this.authRepo) : super(const VerifyOtpState());

  Future<void> verifyOtp({required String phone, required String code}) async {
    emit(state.copyWith(status: VerifyOtpStatus.loading));
    final result = await authRepo.verifyOtp(phone: phone, code: code);
    result.fold(
      (failure) => emit(
        state.copyWith(status: VerifyOtpStatus.failure, failure: failure),
      ),
      (user) => emit(
        state.copyWith(status: VerifyOtpStatus.success, userModel: user),
      ),
    );
  }
}
