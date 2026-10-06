part of 'send_otp_cubit.dart';

enum SendOtpStatus { initial, loading, success, failure }

extension SendOtpStatusX on SendOtpState {
  bool get isInitial => status == SendOtpStatus.initial;

  bool get isLoading => status == SendOtpStatus.loading;

  bool get isSuccess => status == SendOtpStatus.success;

  bool get isFailure => status == SendOtpStatus.failure;
}

class SendOtpState extends Equatable {
  final SendOtpStatus status;
  final AppFailure? failure;
  final String phone;

  const SendOtpState({
    this.status = SendOtpStatus.initial,
    this.failure,
    this.phone = '',
  });

  SendOtpState copyWith({
    SendOtpStatus? status,
    AppFailure? failure,
    String? phone,
  }) {
    return SendOtpState(
      status: status ?? this.status,
      failure: failure,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object?> get props => [status, failure, phone];
}
