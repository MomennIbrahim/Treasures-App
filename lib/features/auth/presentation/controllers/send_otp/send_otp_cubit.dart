import 'package:equatable/equatable.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/helper/format_egyption_number.dart';
import 'package:konoz/features/auth/data/repo/auth_repo.dart';

part 'send_otp_state.dart';

class SendOtpCubit extends SafeCubit<SendOtpState> {
  final AuthRepo authRepo;
  SendOtpCubit(this.authRepo)
    : super(SendOtpState(status: SendOtpStatus.initial));

  Future<void> sendOtp({required String rawPhone}) async {
    final phone = formatEgyptPhone(rawPhone);

    emit(state.copyWith(status: SendOtpStatus.loading, phone: phone));
    final result = await authRepo.sendOtp(phone: phone);
    result.fold(
      (failure) =>
          emit(state.copyWith(status: SendOtpStatus.failure, failure: failure)),
      (_) => emit(state.copyWith(status: SendOtpStatus.success)),
    );
  }
}
