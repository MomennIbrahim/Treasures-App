part of 'currently_trending_cubit.dart';

enum CurrentlyTrendingStatus { initial, loading, success, failure }

extension CurrentlyTrendingStatusX on CurrentlyTrendingState {
  bool get isInitial => status == CurrentlyTrendingStatus.initial;

  bool get isLoading => status == CurrentlyTrendingStatus.loading;

  bool get isSuccess => status == CurrentlyTrendingStatus.success;

  bool get isFailure => status == CurrentlyTrendingStatus.failure;

  bool get isLoadingMore => list.isLoadingMore;
}

class CurrentlyTrendingState extends Equatable {
  final CurrentlyTrendingStatus status;
  final PagedList<ProductItemModel> list;
  final AppFailure? failure;

  const CurrentlyTrendingState({
    this.status = CurrentlyTrendingStatus.initial,
    this.list = const PagedList(),
    this.failure,
  });

  List<ProductItemModel> get products => list.items;

  // failure بيتصفّر عن قصد
  CurrentlyTrendingState copyWith({
    CurrentlyTrendingStatus? status,
    PagedList<ProductItemModel>? list,
    AppFailure? failure,
  }) {
    return CurrentlyTrendingState(
      status: status ?? this.status,
      list: list ?? this.list,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, list, failure];
}