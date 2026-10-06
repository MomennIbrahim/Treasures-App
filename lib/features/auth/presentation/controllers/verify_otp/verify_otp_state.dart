part of 'verify_otp_cubit.dart';

enum VerifyOtpStatus { initial, loading, success, failure }

extension VerifyOtpStatusX on VerifyOtpState {
  bool get isInitial => status == VerifyOtpStatus.initial;

  bool get isLoading => status == VerifyOtpStatus.loading;

  bool get isSuccess => status == VerifyOtpStatus.success;

  bool get isFailure => status == VerifyOtpStatus.failure;
}

@immutable
class VerifyOtpState extends Equatable {
  final VerifyOtpStatus status;
  final UserModel? userModel;
  final AppFailure? failure;

  const VerifyOtpState({
    this.status = VerifyOtpStatus.initial,
    this.userModel,
    this.failure,
  });

  VerifyOtpState copyWith({
    VerifyOtpStatus? status,
    AppFailure? failure,
    UserModel? userModel,
  }) {
    return VerifyOtpState(
      status: status ?? this.status,
      failure: failure,
      userModel: userModel ?? this.userModel,
    );
  }

  @override
  List<Object?> get props => [status, userModel, failure];
}
