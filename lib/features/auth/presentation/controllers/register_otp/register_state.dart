part of 'register_cubit.dart';

enum RegisterStatus { initial, loading, success, failure }

extension RegisterStatusX on RegisterState {
  bool get isInitial => status == RegisterStatus.initial;

  bool get isLoading => status == RegisterStatus.loading;

  bool get isSuccess => status == RegisterStatus.success;

  bool get isFailure => status == RegisterStatus.failure;
}

class RegisterState extends Equatable {
  final RegisterStatus status;
  final AppFailure? failure;
  final AuthResponseModel? auth;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.failure,
    this.auth,
  });

  // failure بيتصفّر عن قصد
  RegisterState copyWith({
    RegisterStatus? status,
    AppFailure? failure,
    AuthResponseModel? auth,
  }) {
    return RegisterState(
      status: status ?? this.status,
      failure: failure,
      auth: auth ?? this.auth,
    );
  }

  @override
  List<Object?> get props => [status, failure, auth];
}