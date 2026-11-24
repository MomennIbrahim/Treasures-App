part of 'best_selling_cubit.dart';

enum BestSellingStatus { initial, loading, success, failure }

extension BestSellingStatusX on BestSellingState {
  bool get isInitial => status == BestSellingStatus.initial;

  bool get isLoading => status == BestSellingStatus.loading;

  bool get isSuccess => status == BestSellingStatus.success;

  bool get isFailure => status == BestSellingStatus.failure;

  bool get isLoadingMore => list.isLoadingMore;
}

class BestSellingState extends Equatable {
  final BestSellingStatus status;
  final PagedList<ProductItemModel> list;
  final AppFailure? failure;

  const BestSellingState({
    this.status = BestSellingStatus.initial,
    this.list = const PagedList(),
    this.failure,
  });

  List<ProductItemModel> get products => list.items;

  // failure بيتصفّر عن قصد
  BestSellingState copyWith({
    BestSellingStatus? status,
    PagedList<ProductItemModel>? list,
    AppFailure? failure,
  }) {
    return BestSellingState(
      status: status ?? this.status,
      list: list ?? this.list,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, list, failure];
}