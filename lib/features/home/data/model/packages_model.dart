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

  static List<PackageItemModel> emptyList() =>
      List.generate(3, (_) => PackageItemModel.empty());

  factory PackagesModel.fromJson(Map<String, dynamic> json) {
    return PackagesModel(
      success: json['success'],
      message: json['message'],
      packages: json['data'] == null
          ? []
          : (json['data'] as List)
                .map(
                  (e) => PackageItemModel.fromJson(e as Map<String, dynamic>),
                )
                .toList(),
      // pagination: json['pagination'] == null
      //     ? null
      //     : PaginationModel.fromJson(
      //         json['pagination'] as Map<String, dynamic>,
      //       ),
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
  final bool isAvailable;

  const PackageItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.discountPrice,
    required this.discountPercentage,
    required this.size,
    required this.isAvailable,
  });

  factory PackageItemModel.empty() {
    return const PackageItemModel(
      id: 0,
      name: 'Package Name',
      description: 'Package Description',
      image: 'https://via.placeholder.com/600x600',
      price: '1000',
      discountPrice: '750',
      discountPercentage: '25%',
      size: '3 × 50ml',
      isAvailable: true,
    );
  }
  factory PackageItemModel.fromJson(Map<String, dynamic> json) {
    return PackageItemModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
      price: json['price']?.toString() ?? '0',
      discountPrice: json['discount_price']?.toString() ?? '0',
      discountPercentage: json['discount_percentage']?.toString() ?? '0%',
      size: json['size']?.toString() ?? '',
      isAvailable: json['is_available'] == true,
    );
  }
}
