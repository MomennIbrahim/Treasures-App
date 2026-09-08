import 'package:equatable/equatable.dart';

class ProductDetailsModel extends Equatable {
  final int id;
  final String name;
  final List<String> images;
  final List<ProductSizeModel> sizes;
  final String longevity;
  final String sillage;
  final double rate;
  final String description;
  final HowToUseModel? howToUse;
  final List<String> ingredients;
  final String details;

  const ProductDetailsModel({
    required this.id,
    required this.name,
    required this.images,
    required this.sizes,
    required this.longevity,
    required this.sillage,
    required this.rate,
    required this.description,
    this.howToUse,
    required this.ingredients,
    required this.details,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      id: json['id'] as int,
      name: json['name'] as String,
      images: List<String>.from(json['images'] ?? []),
      sizes: (json['sizes'] as List<dynamic>? ?? [])
          .map((e) => ProductSizeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      longevity: json['longevity'] as String? ?? '',
      sillage: json['sillage'] as String? ?? '',
      rate: (json['rate'] as num?)?.toDouble() ?? 0,
      description: json['description'] as String? ?? '',
      howToUse: json['how_to_use'] != null
          ? HowToUseModel.fromJson(json['how_to_use'] as Map<String, dynamic>)
          : null,
      ingredients: List<String>.from(json['ingredients'] ?? []),
      details: json['details'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'images': images,
      'sizes': sizes.map((e) => e.toJson()).toList(),
      'longevity': longevity,
      'sillage': sillage,
      'rate': rate,
      'description': description,
      'how_to_use': howToUse?.toJson(),
      'ingredients': ingredients,
      'details': details,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    images,
    sizes,
    longevity,
    sillage,
    rate,
    description,
    howToUse,
    ingredients,
    details,
  ];
}

class ProductSizeModel extends Equatable {
  final int id;
  final int value;
  final String unit;
  final double price;
  final double? oldPrice;
  final double? discountPercentage;
  final int stock;

  const ProductSizeModel({
    required this.id,
    required this.value,
    required this.unit,
    required this.price,
    this.oldPrice,
    this.discountPercentage,
    required this.stock,
  });

  factory ProductSizeModel.fromJson(Map<String, dynamic> json) {
    return ProductSizeModel(
      id: json['id'] as int,
      value: json['value'] as int,
      unit: json['unit'] as String? ?? 'ml',
      price: (json['price'] as num).toDouble(),
      oldPrice: (json['old_price'] as num?)?.toDouble(),
      discountPercentage: (json['discount_percentage'] as num?)?.toDouble(),
      stock: json['stock'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'unit': unit,
      'price': price,
      'old_price': oldPrice,
      'discount_percentage': discountPercentage,
      'stock': stock,
    };
  }

  String get displayName => '$value $unit';

  bool get isAvailable => stock > 0;

  @override
  List<Object?> get props => [
    id,
    value,
    unit,
    price,
    oldPrice,
    discountPercentage,
    stock,
  ];
}

class HowToUseModel extends Equatable {
  final String title;
  final List<String> steps;

  const HowToUseModel({required this.title, required this.steps});

  factory HowToUseModel.fromJson(Map<String, dynamic> json) {
    return HowToUseModel(
      title: json['title'] as String? ?? '',
      steps: List<String>.from(json['steps'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'steps': steps};
  }

  @override
  List<Object?> get props => [title, steps];
}
