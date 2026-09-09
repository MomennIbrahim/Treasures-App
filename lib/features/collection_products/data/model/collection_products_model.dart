import 'package:konoz/core/shared_model.dart/pagination_model.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';

class CollectionProductsModel {
  final bool success;
  final String message;
  final List<ProductItemModel> products;
  final PaginationModel pagination;

  const CollectionProductsModel({
    required this.success,
    required this.message,
    required this.products,
    required this.pagination,
  });

  factory CollectionProductsModel.fromJson(Map<String, dynamic> json) {
    return CollectionProductsModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      products: (json['products'] as List<dynamic>? ?? [])
          .map((e) => ProductItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: PaginationModel.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );
  }
}