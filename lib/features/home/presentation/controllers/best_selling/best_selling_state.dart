part of 'best_selling_cubit.dart';

enum BestSellingStatus {
  initial,
  loading,
  loadingMore,
  success,
  failure,
}

extension BestSellingStatusX on BestSellingState {
  bool get isInitial => status == BestSellingStatus.initial;

  bool get isLoading => status == BestSellingStatus.loading;

  bool get isLoadingMore => status == BestSellingStatus.loadingMore;

  bool get isSuccess => status == BestSellingStatus.success;

  bool get isFailure => status == BestSellingStatus.failure;
}

@immutable
class BestSellingState extends Equatable {
  final BestSellingStatus status;
  final BestSellingModel? bestSelling;
  final AppFailure? failure;

  const BestSellingState({
    this.status = BestSellingStatus.initial,
    this.bestSelling,
    this.failure,
  });

  BestSellingState copyWith({
    BestSellingStatus? status,
    BestSellingModel? bestSelling,
    AppFailure? failure,
    bool clearFailure = false,
  }) {
    return BestSellingState(
      status: status ?? this.status,
      bestSelling: bestSelling ?? this.bestSelling,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
        status,
        bestSelling,
        failure,
      ];
}