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

  factory CurrentlyTrendingModel.fromJson(Map<String, dynamic> json) {
    return CurrentlyTrendingModel(
      success: json['success'],
      message: json['message'],
      products: json['data'] == null
          ? []
          : (json['data'] as List)
                .map(
                  (e) => ProductItemModel.fromJson(e as Map<String, dynamic>),
                )
                .toList(),
      pagination: json['pagination'] == null
          ? null
          : PaginationModel.fromJson(
              json['pagination'] as Map<String, dynamic>,
            ),
    );
  }
}
