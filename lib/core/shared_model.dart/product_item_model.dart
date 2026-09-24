import 'package:konoz/features/product_details/data/model/product_details_model.dart';

class ProductItemModel {
  final String collectionId;
  final String name;
  final String description;
  final String image;
  final String rating;
  final String reviewCount;
  final bool inStock;
  final String defaultSize;
  final String defaultPrice;
  final String? defaultDiscountPrice;
  final String? defaultDiscountPercentage;
  final bool isFavorite;
  final List<ProductSizeModel> sizes;
  final List<String> images;

  const ProductItemModel({
    required this.collectionId,
    required this.name,
    required this.description,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.inStock,
    required this.defaultSize,
    required this.defaultPrice,
    this.defaultDiscountPrice,
    this.defaultDiscountPercentage,
    required this.isFavorite,
    required this.sizes,
    required this.images,
  });

  factory ProductItemModel.empty() {
    return const ProductItemModel(
      collectionId: "1",
      name: 'placeholder name',
      description: 'placeholder description text here',
      image:
          'https://i.pinimg.com/736x/91/46/b1/9146b1806b9cc89d22d12ccb987e0d5a.jpg',
      rating: '0.0',
      reviewCount: '00',
      inStock: true,
      defaultSize: '-',
      defaultPrice: '0',
      isFavorite: false,
      sizes: [],
      images: [],
    );
  }

  factory ProductItemModel.fromJson(Map<String, dynamic> json) {
    return ProductItemModel(
      collectionId: json['collection_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      rating: json['rating'].toString(),
      reviewCount: json['review_count'].toString(),
      inStock: json['in_stock'] == 1,
      defaultSize: json['default_size'].toString(),
      defaultPrice: json['default_price'].toString(),
      defaultDiscountPrice: json['default_discount_price']?.toString(),
      defaultDiscountPercentage: json['default_discount_percentage']
          ?.toString(),
      isFavorite: json['is_favorite'] == 1,
      sizes: (json['sizes'] as List<dynamic>? ?? [])
          .map((e) => ProductSizeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      images: (json['images'] as List<dynamic>? ?? []).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'collection_id': collectionId,
      'name': name,
      'description': description,
      'image': image,
      'rating': rating,
      'review_count': reviewCount,
      'in_stock': inStock,
      'default_size': defaultSize,
      'default_price': defaultPrice,
      'default_discount_price': defaultDiscountPrice,
      'default_discount_percentage': defaultDiscountPercentage,
      'is_favorite': isFavorite,
      'is_best_seller': true,
      'is_currently_trending': true,
      'sizes': sizes.map((e) => e.toJson()).toList(),
      'images': images
    };
  }
}
