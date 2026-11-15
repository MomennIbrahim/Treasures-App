part of 'collection_products_cubit.dart';

enum CollectionProductsStatus { initial, loading, success, failure }

class CollectionProductsState extends Equatable {
  /// '' يعني All. غير كده id المجموعة النصي زي "oud".
  final String selectedCollectionId;
  final CollectionProductsStatus status;
  final List<ProductItemModel> products;
  final AppFailure? failure;

  const CollectionProductsState({
    this.selectedCollectionId = '',
    this.status = CollectionProductsStatus.initial,
    this.products = const [],
    this.failure,
  });

  bool get isInitial => status == CollectionProductsStatus.initial;
  bool get isLoading => status == CollectionProductsStatus.loading;
  bool get isSuccess => status == CollectionProductsStatus.success;
  bool get isFailure => status == CollectionProductsStatus.failure;

  CollectionProductsState copyWith({
    String? selectedCollectionId,
    CollectionProductsStatus? status,
    List<ProductItemModel>? products,
    AppFailure? failure,
  }) {
    return CollectionProductsState(
      selectedCollectionId: selectedCollectionId ?? this.selectedCollectionId,
      status: status ?? this.status,
      products: products ?? this.products,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [selectedCollectionId, status, products, failure];
}