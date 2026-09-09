part of 'collection_products_cubit.dart';

enum CollectionProductsStatus { initial, loading, loadingMore, success, failure }

extension CollectionProductsStatusX on CollectionProductsState {
  bool get isInitial => status == CollectionProductsStatus.initial;
  bool get isLoading => status == CollectionProductsStatus.loading;
  bool get isLoadingMore => status == CollectionProductsStatus.loadingMore;
  bool get isSuccess => status == CollectionProductsStatus.success;
  bool get isFailure => status == CollectionProductsStatus.failure;
}

@immutable
class CollectionProductsState extends Equatable {
  final CollectionProductsStatus status;
  final int? selectedCategoryId;
  final List<ProductItemModel> products;
  final PaginationModel? pagination;
  final AppFailure? failure;

  const CollectionProductsState({
    this.status = CollectionProductsStatus.initial,
    this.selectedCategoryId,
    this.products = const [],
    this.pagination,
    this.failure,
  });

  bool get hasReachedMax =>
      pagination != null && pagination!.currentPage >= pagination!.lastPage;

  CollectionProductsState copyWith({
    CollectionProductsStatus? status,
    int? selectedCategoryId,
    List<ProductItemModel>? products,
    PaginationModel? pagination,
    AppFailure? failure,
    bool clearFailure = false,
  }) {
    return CollectionProductsState(
      status: status ?? this.status,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      products: products ?? this.products,
      pagination: pagination ?? this.pagination,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props =>
      [status, selectedCategoryId, products, pagination, failure];
}