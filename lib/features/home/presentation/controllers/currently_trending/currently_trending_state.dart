part of 'currently_trending_cubit.dart';

enum CurrentlyTrendingStatus { initial, loading, loadingMore, success, failure }

extension CurrentlyTrendingStatusX on CurrentlyTrendingState {
  bool get isInitial => status == CurrentlyTrendingStatus.initial;

  bool get isLoading => status == CurrentlyTrendingStatus.loading;

  bool get isLoadingMore => status == CurrentlyTrendingStatus.loadingMore;

  bool get isSuccess => status == CurrentlyTrendingStatus.success;

  bool get isFailure => status == CurrentlyTrendingStatus.failure;
}

@immutable
class CurrentlyTrendingState extends Equatable {
  final CurrentlyTrendingStatus status;
  final CurrentlyTrendingModel? currentlyTrending;
  final AppFailure? failure;

  const CurrentlyTrendingState({
    this.status = CurrentlyTrendingStatus.initial,
    this.currentlyTrending,
    this.failure,
  });

  CurrentlyTrendingState copyWith({
    CurrentlyTrendingStatus? status,
    CurrentlyTrendingModel? currentlyTrending,
    AppFailure? failure,
    bool clearFailure = false,
  }) {
    return CurrentlyTrendingState(
      status: status ?? this.status,
      currentlyTrending: currentlyTrending ?? this.currentlyTrending,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, currentlyTrending, failure];
}
