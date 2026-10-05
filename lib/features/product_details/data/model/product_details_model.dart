import 'dart:convert';

import 'package:equatable/equatable.dart';

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

  // Empty constructor
  ProductDetailsModel.empty()
    : id = 0,
      name = 'Product name here',
      images = const ['', ''],
      reviewCount = "1",
      sizes = const [
        ProductSizeModel(
          id: '0',
          value: '100',
          unit: 'ml',
          discountPrice: '000',
          price: '000',

          discountPercentage: '0',
          inStock: '1',
        ),
        ProductSizeModel(
          id: '1',
          value: '50',
          unit: 'ml',
          discountPrice: '000',
          price: '000',
          discountPercentage: '0',
          inStock: '1',
        ),
      ],
      longevity = 'Long lasting',
      sillage = 'Moderate',
      rate = "0",
      description = 'Placeholder description text for the loading state',
      howToUse = const [],
      notes = FragranceNotesModel.empty(),
      details = 'Placeholder details text for the loading state';

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> asList(dynamic value) {
      if (value is List) return value;
      if (value is String && value.trim().isNotEmpty) {
        try {
          final decoded = jsonDecode(value);
          if (decoded is List) return decoded;
        } catch (_) {}
      }
      return [];
    }

    Map<String, dynamic> asMap(dynamic value) {
      if (value is Map<String, dynamic>) return value;
      if (value is String && value.trim().isNotEmpty) {
        try {
          final decoded = jsonDecode(value);
          if (decoded is Map<String, dynamic>) return decoded;
        } catch (_) {}
      }
      return {};
    }

    return ProductDetailsModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      images: asList(json['images']).map((e) => e.toString()).toList(),
      sizes: asList(json['sizes'])
          .map((e) => ProductSizeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      longevity: json['longevity']?.toString() ?? '',
      sillage: json['sillage']?.toString() ?? '',
      rate: json['rating']?.toString() ?? '0',
      reviewCount: json['review_count']?.toString() ?? '0',
      description: json['description']?.toString() ?? '',
      howToUse: asList(json['how_to_use']).map((e) => e.toString()).toList(),
      notes: FragranceNotesModel.fromJson(asMap(json['notes'])),
      details: json['details']?.toString() ?? '',
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

// ─────────────────────────────────────────────
// Product Size
// ─────────────────────────────────────────────

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
    return ProductSizeModel(
      id: json['id'].toString(),
      value: json['value'].toString(),
      unit: json['unit']?.toString() ?? 'ml',
      discountPrice: (json['discount_price'] ?? json['price'] ?? 0).toString(),
      price: json['price']?.toString(),
      discountPercentage: json['discount_percentage']?.toString(),
      inStock: json['in_stock']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'unit': unit,
      'price': price, // كانت متبدلة
      'discount_price': discountPrice,
      'discount_percentage': discountPercentage,
      'in_stock': inStock, // كانت 'stock'
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

// ─────────────────────────────────────────────
// Fragrance Notes
// ─────────────────────────────────────────────

class FragranceNotesModel extends Equatable {
  final List<FragranceNoteModel> topNotes;
  final List<FragranceNoteModel> heartNotes;
  final List<FragranceNoteModel> baseNotes;

  const FragranceNotesModel({
    required this.topNotes,
    required this.heartNotes,
    required this.baseNotes,
  });

  // Empty
  factory FragranceNotesModel.empty() =>
      const FragranceNotesModel(topNotes: [], heartNotes: [], baseNotes: []);

  factory FragranceNotesModel.fromJson(Map<String, dynamic> json) {
    return FragranceNotesModel(
      topNotes: (json['top_notes'] as List<dynamic>? ?? [])
          .map((e) => FragranceNoteModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      heartNotes: (json['heart_notes'] as List<dynamic>? ?? [])
          .map((e) => FragranceNoteModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      baseNotes: (json['base_notes'] as List<dynamic>? ?? [])
          .map((e) => FragranceNoteModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'top_notes': topNotes.map((e) => e.toJson()).toList(),
      'heart_notes': heartNotes.map((e) => e.toJson()).toList(),
      'base_notes': baseNotes.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [topNotes, heartNotes, baseNotes];
}

// ─────────────────────────────────────────────
// Fragrance Note
// ─────────────────────────────────────────────

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
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }

  // Empty
  static FragranceNoteModel empty() =>
      const FragranceNoteModel(id: 0, name: '', image: '');

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image': image};
  }

  @override
  List<Object?> get props => [id, name, image];
}
