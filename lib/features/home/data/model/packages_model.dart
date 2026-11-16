
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
      packages: (json['data'] as List? ?? [])
          .map(
            (e) => PackageItemModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}

class PackageItemModel {
  final String id;
  final String name;
  final String price;
  final String image;
  final List<PackageProductModel> items;

  const PackageItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.items,
  });

  factory PackageItemModel.empty() {
    return PackageItemModel(
      id: '',
      name: 'Package Name',
      price: '370',
      image: '',
      items: [
        PackageProductModel.empty(),
        PackageProductModel.empty(),
      ],
    );
  }

  factory PackageItemModel.fromJson(Map<String, dynamic> json) {
    return PackageItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: json['price']?.toString() ?? '0',
      items: (json['items'] as List? ?? [])
          .map(
            (e) => PackageProductModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}

class PackageProductModel {
  final String productId;
  final String name;
  final String image;
  final String quantity;
  final String price;
  final String total;

  const PackageProductModel({
    required this.productId,
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
    required this.total,
  });

  factory PackageProductModel.empty() {
    return const PackageProductModel(
      productId: '',
      name: 'Product Name',
      image: '',
      quantity: '1',
      price: '0',
      total: '0',
    );
  }

  factory PackageProductModel.fromJson(Map<String, dynamic> json) {
    return PackageProductModel(
      productId: json['product_id']?.toString() ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      quantity: json['quantity']?.toString() ?? '0',
      price: json['price']?.toString() ?? '0',
      total: json['total']?.toString() ?? '0',
    );
  }
}
