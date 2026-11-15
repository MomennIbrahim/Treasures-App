import 'package:konoz/core/shared_model.dart/pagination_model.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';

class CollectionProductsModel {
  final bool success;
  final String message;
  final List<ProductItemModel> products;
  final PaginationModel? pagination;

  const CollectionProductsModel({
    required this.success,
    required this.message,
    required this.products,
    required this.pagination,
  });

  /// الرد من GET /products: { "data": [ ... ] }
  factory CollectionProductsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json['products'];

    return CollectionProductsModel(
      success: json['success'] as bool? ?? json['succeeded'] as bool? ?? true,
      message: json['message'] as String? ?? '',
      products: data is List
          ? data
                .whereType<Map<String, dynamic>>()
                .map(ProductItemModel.fromApi)
                .toList()
          : const [],
      // الـ API مفيهاش pagination.
      pagination: json['pagination'] is Map<String, dynamic>
          ? PaginationModel.fromJson(
              json['pagination'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}