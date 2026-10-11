part of 'collection_products_cubit.dart';

enum CollectionProductsStatus { initial, loading, success, failure }

extension CollectionProductsStatusX on CollectionProductsState {
  bool get isInitial => status == CollectionProductsStatus.initial;
  bool get isLoading => status == CollectionProductsStatus.loading;
  bool get isSuccess => status == CollectionProductsStatus.success;
  bool get isFailure => status == CollectionProductsStatus.failure;
}

@immutable
class CollectionProductsState extends Equatable {
  final CollectionProductsStatus status;

  /// 0 = All، -1 = لسه ما اتحددش
  final int selectedCollectionId;
  final List<ProductItemModel> products;
  final AppFailure? failure;

  const CollectionProductsState({
    this.status = CollectionProductsStatus.initial,
    this.selectedCollectionId = -1,
    this.products = const [],
    this.failure,
  });

  // failure بيتصفّر عن قصد
  CollectionProductsState copyWith({
    CollectionProductsStatus? status,
    int? selectedCollectionId,
    List<ProductItemModel>? products,
    AppFailure? failure,
  }) {
    return CollectionProductsState(
      status: status ?? this.status,
      selectedCollectionId: selectedCollectionId ?? this.selectedCollectionId,
      products: products ?? this.products,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, selectedCollectionId, products, failure];
}