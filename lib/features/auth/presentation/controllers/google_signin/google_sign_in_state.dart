part of 'google_sign_in_cubit.dart';

enum GoogleStatus { initial, loading, success, failure }

class GoogleSignInState extends Equatable {
  final GoogleStatus status;
  final AppFailure? failure;

  const GoogleSignInState({this.status = GoogleStatus.initial, this.failure});

  bool get isLoading => status == GoogleStatus.loading;
  bool get isSuccess => status == GoogleStatus.success;
  bool get isFailure => status == GoogleStatus.failure;

  // failure بيتصفّر عن قصد
  GoogleSignInState copyWith({GoogleStatus? status, AppFailure? failure}) =>
      GoogleSignInState(status: status ?? this.status, failure: failure);

  @override
  List<Object?> get props => [status, failure];
}