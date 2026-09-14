import 'package:konoz/core/shared_model.dart/pagination_model.dart';

class PackagesModel {
  final bool? success;
  final String? message;
  final List<PackageItemModel> packages;
  final PaginationModel? pagination;

  const PackagesModel({
    this.success,
    this.message,
    required this.packages,
    this.pagination,
  });

  factory PackagesModel.fromJson(Map<String, dynamic> json) {
    return PackagesModel(
      success: json['success'],
      message: json['message'],
      packages: json['data'] == null
          ? []
          : (json['data'] as List)
                .map(
                  (e) => PackageItemModel.fromJson(
                    e as Map<String, dynamic>,
                  ),
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

class PackageItemModel {
  final int id;
  final String name;
  final String description;
  final String image;
  final String price;
  final String discountPrice;
  final String discountPercentage;
  final String size;
  final bool inStock;

  const PackageItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.discountPrice,
    required this.discountPercentage,
    required this.size,
    required this.inStock,
  });

  factory PackageItemModel.fromJson(Map<String, dynamic> json) {
    return PackageItemModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      price: json['price'].toString(),
      discountPrice: json['discount_price'].toString(),
      discountPercentage: json['discount_percentage'].toString(),
      size: json['size'].toString(),
      inStock: json['in_stock'] == 1,
    );
  }
}