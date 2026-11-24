part of 'packages_cubit.dart';

enum PackagesStatus { initial, loading, success, failure }

extension PackagesStatusX on PackagesState {
  bool get isInitial => status == PackagesStatus.initial;

  bool get isLoading => status == PackagesStatus.loading;

  bool get isSuccess => status == PackagesStatus.success;

  bool get isFailure => status == PackagesStatus.failure;

  bool get isLoadingMore => list.isLoadingMore;
}

class PackagesState extends Equatable {
  final PackagesStatus status;
  final PagedList<PackageItemModel> list;
  final AppFailure? failure;

  const PackagesState({
    this.status = PackagesStatus.initial,
    this.list = const PagedList(),
    this.failure,
  });

  List<PackageItemModel> get packages => list.items;

  // failure بيتصفّر عن قصد
  PackagesState copyWith({
    PackagesStatus? status,
    PagedList<PackageItemModel>? list,
    AppFailure? failure,
  }) {
    return PackagesState(
      status: status ?? this.status,
      list: list ?? this.list,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, list, failure];
}