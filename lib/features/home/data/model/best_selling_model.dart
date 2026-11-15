import 'package:konoz/core/shared_model.dart/pagination_model.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';

class BestSellingModel {
  final bool? success;
  final String? message;
  final List<ProductItemModel> products;
  final PaginationModel? pagination;

  const BestSellingModel({
    this.success,
    this.message,
    required this.products,
    this.pagination,
  });

  /// عناصر وهمية للـ Skeletonizer.
  static List<ProductItemModel> emptyList() => [
    ProductItemModel.empty(),
    ProductItemModel.empty(),
    ProductItemModel.empty(),
  ];

  /// الرد من GET /top-sellers:
  /// { "data": { "id": "top-sellers", "name": "...", "products": [ ... ] } }
  factory BestSellingModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final rawProducts = data is Map
        ? data['products']
        : data; // لو رجعت قائمة مباشرة

    return BestSellingModel(
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