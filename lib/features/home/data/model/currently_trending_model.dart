import 'package:konoz/core/shared_model.dart/pagination_model.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';

class CurrentlyTrendingModel {
  final bool? success;
  final String? message;
  final List<ProductItemModel> products;
  final PaginationModel? pagination;

  const CurrentlyTrendingModel({
    this.success,
    this.message,
    required this.products,
    this.pagination,
  });

  /// الرد من GET /trending:
  /// { "data": { "id": "trending", "name": "...", "products": [ ... ] } }
  factory CurrentlyTrendingModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final rawProducts = data is Map
        ? data['products']
        : data; // لو رجعت قائمة مباشرة

    return CurrentlyTrendingModel(
      success: json['success'] as bool? ?? json['succeeded'] as bool?,
      message: json['message'] as String?,
      products: rawProducts is List
          ? rawProducts
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