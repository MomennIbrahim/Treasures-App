part of 'banners_cubit.dart';

enum BannersStatus { initial, loading, success, failure }

extension BannersStatusX on BannersState {
  bool get isInitial => status == BannersStatus.initial;
  bool get isLoading => status == BannersStatus.loading;
  bool get isSuccess => status == BannersStatus.success;
  bool get isFailure => status == BannersStatus.failure;
}

@immutable
class BannersState extends Equatable {
  final BannersStatus status;
  final BannersModel? banners;
  final AppFailure? failure;

  const BannersState({
    this.status = BannersStatus.initial,
    this.banners,
    this.failure,
  });

  BannersState copyWith({
    BannersStatus? status,
    BannersModel? banners,
    AppFailure? failure,
  }) {
    return BannersState(
      status: status ?? this.status,
      banners: banners ?? this.banners,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, banners, failure];
}
