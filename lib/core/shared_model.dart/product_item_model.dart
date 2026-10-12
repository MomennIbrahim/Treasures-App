import 'package:konoz/features/product_details/data/model/product_details_model.dart';

class ProductItemModel {
  final int id;
  final String collectionId;
  final String name;
  final String description;
  final String image;
  final String rating;
  final String reviewCount;
  final bool inStock;
  final int? defaultSizeId;
  final String defaultSize;
  final String defaultPrice;
  final String? defaultDiscountPrice;
  final String? defaultDiscountPercentage;
  final bool isFavorite;
  final List<ProductSizeModel> sizes;
  final List<String> images;

  const ProductItemModel({
    required this.id,
    required this.collectionId,
    required this.name,
    required this.description,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.inStock,
    this.defaultSizeId,
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
      id: 0,
      collectionId: '1',
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

  factory ProductItemModel.fromSupabase(Map<String, dynamic> json) {
    final rawImages = json['images'];

    final images = rawImages is List
        ? rawImages.map((item) => item.toString()).toList()
        : <String>[];

    final rawSizes = json['product_sizes'];

    final sizes =
        (rawSizes is List ? rawSizes : [])
            .whereType<Map>()
            .map(
              (item) =>
                  ProductSizeModel.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList()
          ..sort(
            (a, b) =>
                (int.tryParse(a.id) ?? 0).compareTo(int.tryParse(b.id) ?? 0),
          );

    // أول مقاس متاح، أو أول مقاس لو كل المقاسات غير متاحة.
    final ProductSizeModel? defaultSize = sizes.isEmpty
        ? null
        : sizes.firstWhere(
            (size) => size.isAvailable,
            orElse: () => sizes.first,
          );

    final originalPrice = _parsePrice(defaultSize?.price);
    final discountedPrice = _parsePrice(defaultSize?.discountPrice);

    final hasDiscount =
        originalPrice != null &&
        discountedPrice != null &&
        discountedPrice > 0 &&
        discountedPrice < originalPrice;

    final displayedPrice = originalPrice ?? discountedPrice ?? 0;

    return ProductItemModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      collectionId: json['collection_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      image: images.isNotEmpty ? images.first : '',
      rating: json['rating']?.toString() ?? '0',
      reviewCount: json['review_count']?.toString() ?? '0',
      inStock: sizes.any((size) => size.isAvailable),
      defaultSizeId: int.tryParse(defaultSize?.id ?? ''),
      defaultSize: defaultSize?.displayName ?? '-',
      defaultPrice: _formatPrice(displayedPrice),
      defaultDiscountPrice: hasDiscount ? _formatPrice(discountedPrice) : null,
      defaultDiscountPercentage: hasDiscount
          ? (defaultSize?.discountPercentage ??
                _calculateDiscountPercentage(originalPrice, discountedPrice))
          : null,
      isFavorite: false,
      sizes: sizes,
      images: images,
    );
  }

  static double? _parsePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    return double.tryParse(value.trim());
  }

  static String _formatPrice(double value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
  }

  static String _calculateDiscountPercentage(
    double originalPrice,
    double discountedPrice,
  ) {
    final percentage =
        ((originalPrice - discountedPrice) / originalPrice) * 100;

    return percentage.round().toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'collection_id': collectionId,
      'name': name,
      'description': description,
      'image': image,
      'rating': rating,
      'review_count': reviewCount,
      'in_stock': inStock,
      'default_size_id': defaultSizeId,
      'default_size': defaultSize,
      'default_price': defaultPrice,
      'default_discount_price': defaultDiscountPrice,
      'default_discount_percentage': defaultDiscountPercentage,
      'is_favorite': isFavorite,
      'sizes': sizes.map((item) => item.toJson()).toList(),
      'images': images,
    };
  }
}
