part of 'product_details_cubit.dart';

enum ProductDetailsStatus {
  initial,
  loading,
  success,
  failure,
}

extension ProductDetailsStatusX on ProductDetailsState {
  bool get isInitial =>
      status == ProductDetailsStatus.initial;

  bool get isLoading =>
      status == ProductDetailsStatus.loading;

  bool get isSuccess =>
      status == ProductDetailsStatus.success;

  bool get isFailure =>
      status == ProductDetailsStatus.failure;
}

@immutable
class ProductDetailsState extends Equatable {
  final ProductDetailsStatus status;
  final ProductDetailsModel? product;
  final ProductSizeModel? selectedSize;
  final AppFailure? failure;

  const ProductDetailsState({
    this.status = ProductDetailsStatus.initial,
    this.product,
    this.selectedSize,
    this.failure,
  });

  ProductDetailsState copyWith({
    ProductDetailsStatus? status,
    ProductDetailsModel? product,
    ProductSizeModel? selectedSize,
    AppFailure? failure,
  }) {
    return ProductDetailsState(
      status: status ?? this.status,
      product: product ?? this.product,
      selectedSize: selectedSize ?? this.selectedSize,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
        status,
        product,
        selectedSize,
        failure,
      ];
}