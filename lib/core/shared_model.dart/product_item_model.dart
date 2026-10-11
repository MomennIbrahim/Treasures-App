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

  factory ProductItemModel.fromSupabase(Map<String, dynamic> json) {
    final images = (json['images'] is List)
        ? (json['images'] as List).map((e) => e.toString()).toList()
        : <String>[];

    final sizes =
        ((json['product_sizes'] as List?) ?? [])
            .map((e) => ProductSizeModel.fromJson(e as Map<String, dynamic>))
            .toList()
          ..sort(
            (a, b) =>
                (int.tryParse(a.id) ?? 0).compareTo(int.tryParse(b.id) ?? 0),
          );

    // المقاس الافتراضي: أول مقاس متاح، وإلا أول مقاس
    final def = sizes.isEmpty
        ? null
        : sizes.firstWhere((s) => s.isAvailable, orElse: () => sizes.first);

    final price = double.tryParse(def?.price ?? '') ?? 0;
    final disc = double.tryParse(def?.discountPrice ?? '') ?? 0;
    final hasDiscount = disc > 0 && disc < price;

    return ProductItemModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      collectionId: json['collection_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      image: images.isNotEmpty ? images.first : '',
      rating: json['rating']?.toString() ?? '0',
      reviewCount: json['review_count']?.toString() ?? '0',
      inStock: sizes.any((s) => s.isAvailable),
      defaultSize: def?.displayName ?? '-',
      defaultPrice: (price > 0 ? def!.price : def?.discountPrice) ?? '0',
      defaultDiscountPrice: hasDiscount ? def!.discountPrice : null,
      defaultDiscountPercentage: hasDiscount ? def!.discountPercentage : null,
      isFavorite: false,
      sizes: sizes,
      images: images,
      defaultSizeId: int.tryParse(def?.id ?? ''),
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
      'images': images,
    };
  }
}
