import 'dart:convert';

import 'package:equatable/equatable.dart';

List<dynamic> _asList(dynamic value) {
  if (value is List) return value;

  if (value is String && value.trim().isNotEmpty) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is List) return decoded;
    } catch (_) {}
  }

  return [];
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;

  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }

  if (value is String && value.trim().isNotEmpty) {
    try {
      final decoded = jsonDecode(value);

      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {}
  }

  return {};
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  return int.tryParse(value.toString()) ?? 0;
}

String _toStringValue(dynamic value, [String fallback = '']) {
  if (value == null) return fallback;
  return value.toString();
}

class ProductDetailsModel extends Equatable {
  final int id;
  final String name;
  final List<String> images;
  final List<ProductSizeModel> sizes;
  final String longevity;
  final String sillage;
  final String rate;
  final String reviewCount;
  final String description;
  final List<String> howToUse;
  final FragranceNotesModel notes;
  final String details;

  const ProductDetailsModel({
    required this.id,
    required this.name,
    required this.images,
    required this.sizes,
    required this.longevity,
    required this.sillage,
    required this.rate,
    required this.reviewCount,
    required this.description,
    required this.howToUse,
    required this.notes,
    required this.details,
  });

  ProductDetailsModel.empty()
    : id = 0,
      name = 'Product name here',
      images = const ['', ''],
      sizes = const [
        ProductSizeModel(
          id: '0',
          value: '100',
          unit: 'ml',
          price: '000',
          discountPrice: '000',
          discountPercentage: '0',
          inStock: '1',
        ),
        ProductSizeModel(
          id: '1',
          value: '50',
          unit: 'ml',
          price: '000',
          discountPrice: '000',
          discountPercentage: '0',
          inStock: '1',
        ),
      ],
      longevity = 'Long lasting',
      sillage = 'Moderate',
      rate = '0',
      reviewCount = '1',
      description = 'Placeholder description text for the loading state',
      howToUse = const ['Placeholder step one', 'Placeholder step two'],
      notes = FragranceNotesModel.empty(),
      details = 'Placeholder details text for the loading state';

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    final productSizes = _asList(json['product_sizes']);
    final legacySizes = _asList(json['sizes']);

    final rawSizes = productSizes.isNotEmpty ? productSizes : legacySizes;

    final sizes =
        rawSizes
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

    return ProductDetailsModel(
      id: _toInt(json['id']),
      name: _toStringValue(json['name']),
      images: _asList(json['images']).map((item) => item.toString()).toList(),
      sizes: sizes,
      longevity: _toStringValue(json['longevity']),
      sillage: _toStringValue(json['sillage']),
      rate: _toStringValue(json['rating'], '0'),
      reviewCount: _toStringValue(json['review_count'], '0'),
      description: _toStringValue(json['description']),
      howToUse: _asList(
        json['how_to_use'],
      ).map((item) => item.toString()).toList(),
      notes: FragranceNotesModel.fromJson(_asMap(json['notes'])),
      details: _toStringValue(json['details']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'images': images,
      'product_sizes': sizes.map((item) => item.toJson()).toList(),
      'longevity': longevity,
      'sillage': sillage,
      'rating': rate,
      'review_count': reviewCount,
      'description': description,
      'how_to_use': howToUse,
      'notes': notes.toJson(),
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
    reviewCount,
    description,
    howToUse,
    notes,
    details,
  ];
}

class ProductSizeModel extends Equatable {
  final String id;
  final String value;
  final String unit;
  final String discountPrice;
  final String? price;
  final String? discountPercentage;
  final String? inStock;

  const ProductSizeModel({
    required this.id,
    required this.value,
    required this.unit,
    required this.discountPrice,
    this.price,
    this.discountPercentage,
    required this.inStock,
  });

  factory ProductSizeModel.fromJson(Map<String, dynamic> json) {
    // السعر الأصلي
    final originalPrice = json['price'] ?? json['price_without_discount'];

    // سعر الخصم
    final discountedPrice =
        json['discount_price'] ??
        json['price_with_discount'] ??
        originalPrice ??
        0;

    return ProductSizeModel(
      id: _toStringValue(json['id'], '0'),
      value: _toStringValue(json['value']),
      unit: _toStringValue(json['unit'], 'ml'),
      price: originalPrice?.toString(),
      discountPrice: discountedPrice.toString(),
      discountPercentage:
          (json['discount_percentage'] ?? json['discountPercentage'])
              ?.toString(),
      inStock: (json['in_stock'] ?? json['stock'] ?? json['inStock'] ?? 0)
          .toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'unit': unit,
      'price': price,
      'discount_price': discountPrice,
      'discount_percentage': discountPercentage,
      'in_stock': inStock,
    };
  }

  bool get isAvailable => (int.tryParse(inStock ?? '0') ?? 0) > 0;

  String get displayName => '$value $unit';

  @override
  List<Object?> get props => [
    id,
    value,
    unit,
    discountPrice,
    price,
    discountPercentage,
    inStock,
  ];
}

class FragranceNotesModel extends Equatable {
  final List<FragranceNoteModel> topNotes;
  final List<FragranceNoteModel> heartNotes;
  final List<FragranceNoteModel> baseNotes;

  const FragranceNotesModel({
    required this.topNotes,
    required this.heartNotes,
    required this.baseNotes,
  });

  factory FragranceNotesModel.empty() => FragranceNotesModel(
    topNotes: List.filled(3, FragranceNoteModel.empty()),
    heartNotes: List.filled(3, FragranceNoteModel.empty()),
    baseNotes: List.filled(3, FragranceNoteModel.empty()),
  );

  factory FragranceNotesModel.fromJson(Map<String, dynamic> json) {
    List<FragranceNoteModel> parse(dynamic value) {
      return _asList(value)
          .whereType<Map>()
          .map(
            (item) =>
                FragranceNoteModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    }

    return FragranceNotesModel(
      topNotes: parse(json['top_notes']),
      heartNotes: parse(json['heart_notes']),
      baseNotes: parse(json['base_notes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'top_notes': topNotes.map((item) => item.toJson()).toList(),
      'heart_notes': heartNotes.map((item) => item.toJson()).toList(),
      'base_notes': baseNotes.map((item) => item.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [topNotes, heartNotes, baseNotes];
}

class FragranceNoteModel extends Equatable {
  final int id;
  final String name;
  final String image;

  const FragranceNoteModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory FragranceNoteModel.fromJson(Map<String, dynamic> json) {
    return FragranceNoteModel(
      id: _toInt(json['id']),
      name: _toStringValue(json['name']),
      image: _toStringValue(json['image']),
    );
  }

  static FragranceNoteModel empty() {
    return const FragranceNoteModel(id: 0, name: 'Note', image: '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image': image};
  }

  @override
  List<Object?> get props => [id, name, image];
}
