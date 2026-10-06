part of 'logout_cubit.dart';

enum LogoutStatus { initial, loading, success, failure }

extension LogoutStatusX on LogoutState {
  bool get isInitial => status == LogoutStatus.initial;
  bool get isLoading => status == LogoutStatus.loading;
  bool get isSuccess => status == LogoutStatus.success;
  bool get isFailure => status == LogoutStatus.failure;
}

class LogoutState extends Equatable {
  final LogoutStatus status;
  final AppFailure? failure;

  const LogoutState({this.status = LogoutStatus.initial, this.failure});

  LogoutState copyWith({LogoutStatus? status, AppFailure? failure}) =>
      LogoutState(status: status ?? this.status, failure: failure);

  @override
  List<Object?> get props => [status, failure];
}
