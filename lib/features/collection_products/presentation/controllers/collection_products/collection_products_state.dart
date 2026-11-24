part of 'collection_products_cubit.dart';

enum CollectionProductsStatus { initial, loading, success, failure }

class CollectionProductsState extends Equatable {
  /// '' يعني All. غير كده id المجموعة النصي زي "oud".
  final String selectedCollectionId;
  final CollectionProductsStatus status;

  /// المنتجات المحمّلة لحد دلوقتي + بيانات الصفحات (hasMore / isLoadingMore ...)
  final PagedList<ProductItemModel> list;
  final AppFailure? failure;

  const CollectionProductsState({
    this.selectedCollectionId = '',
    this.status = CollectionProductsStatus.initial,
    this.list = const PagedList(),
    this.failure,
  });

  /// عشان الـ UI القديمة اللي بتقرا state.products تفضل شغالة
  List<ProductItemModel> get products => list.items;

  bool get isInitial => status == CollectionProductsStatus.initial;
  bool get isLoading => status == CollectionProductsStatus.loading;
  bool get isSuccess => status == CollectionProductsStatus.success;
  bool get isFailure => status == CollectionProductsStatus.failure;

  // failure بيتصفّر عن قصد
  CollectionProductsState copyWith({
    String? selectedCollectionId,
    CollectionProductsStatus? status,
    PagedList<ProductItemModel>? list,
    AppFailure? failure,
  }) {
    return CollectionProductsState(
      selectedCollectionId: selectedCollectionId ?? this.selectedCollectionId,
      status: status ?? this.status,
      list: list ?? this.list,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [selectedCollectionId, status, list, failure];
}