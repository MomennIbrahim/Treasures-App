part of 'spin_cubit.dart';

enum SpinLoadStatus { initial, loading, success, failure }

enum SpinRequestStatus { idle, loading, success, failure }

extension SpinLoadStatusX on SpinState {
  bool get isInitial => status == SpinLoadStatus.initial;
  bool get isLoading => status == SpinLoadStatus.loading;
  bool get isSuccess => status == SpinLoadStatus.success;
  bool get isFailure => status == SpinLoadStatus.failure;
}

class SpinState {
  final SpinLoadStatus status; // تحميل العجلة
  final AppFailure? failure;
  final SpinWheelModel? wheel;

  final SpinRequestStatus spinStatus; // تسجيل اللفّة
  final SpinResultModel? result;
  final AppFailure? spinFailure;

  const SpinState({
    this.status = SpinLoadStatus.initial,
    this.failure,
    this.wheel,
    this.spinStatus = SpinRequestStatus.idle,
    this.result,
    this.spinFailure,
  });

  List<SpinSection> get sections => wheel?.sections ?? const [];
  bool get isEnabled => wheel?.enabled ?? false;
  bool get hasSpin => wheel?.hasSpin ?? false;
  bool get isFailure => status == SpinLoadStatus.failure;
  bool get isSpinRequesting => spinStatus == SpinRequestStatus.loading;

  // failure / spinFailure بيتصفّروا عن قصد لو متبعتوش
  // enabled / hasSpin جزء من الـ wheel، فبيتغيروا عن طريق wheel.copyWith(...)
  SpinState copyWith({
    SpinLoadStatus? status,
    AppFailure? failure,
    SpinWheelModel? wheel,
    SpinRequestStatus? spinStatus,
    SpinResultModel? result,
    AppFailure? spinFailure,
  }) {
    return SpinState(
      status: status ?? this.status,
      failure: failure,
      wheel: wheel ?? this.wheel,
      spinStatus: spinStatus ?? this.spinStatus,
      result: result ?? this.result,
      spinFailure: spinFailure,
    );
  }
}