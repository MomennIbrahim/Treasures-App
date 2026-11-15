part of 'login_cubit.dart';

enum LoginStatus { initial, loading, success, failure }

extension LoginStatusX on LoginState {
  bool get isInitial => status == LoginStatus.initial;

  bool get isLoading => status == LoginStatus.loading;

  bool get isSuccess => status == LoginStatus.success;

  bool get isFailure => status == LoginStatus.failure;
}

class LoginState extends Equatable {
  final LoginStatus status;
  final AppFailure? failure;
  final AuthResponseModel? auth;

  const LoginState({
    this.status = LoginStatus.initial,
    this.failure,
    this.auth,
  });

  // failure بيتصفّر عن قصد (من غير ?? this.failure)
  LoginState copyWith({
    LoginStatus? status,
    AppFailure? failure,
    AuthResponseModel? auth,
  }) {
    return LoginState(
      status: status ?? this.status,
      failure: failure,
      auth: auth ?? this.auth,
    );
  }

  @override
  List<Object?> get props => [status, failure, auth];
}