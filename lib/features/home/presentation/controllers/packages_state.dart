part of 'packages_cubit.dart';

enum PackagesStatus {
  initial,
  loading,
  loadingMore,
  success,
  failure,
}

extension PackagesStatusX on PackagesState {
  bool get isInitial => status == PackagesStatus.initial;

  bool get isLoading => status == PackagesStatus.loading;

  bool get isLoadingMore => status == PackagesStatus.loadingMore;

  bool get isSuccess => status == PackagesStatus.success;

  bool get isFailure => status == PackagesStatus.failure;
}

@immutable
class PackagesState extends Equatable {
  final PackagesStatus status;
  final PackagesModel? packages;
  final AppFailure? failure;

  const PackagesState({
    this.status = PackagesStatus.initial,
    this.packages,
    this.failure,
  });

  PackagesState copyWith({
    PackagesStatus? status,
    PackagesModel? packages,
    AppFailure? failure,
    bool clearFailure = false,
  }) {
    return PackagesState(
      status: status ?? this.status,
      packages: packages ?? this.packages,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
        status,
        packages,
        failure,
      ];
}