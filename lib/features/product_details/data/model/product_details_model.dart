
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
  final String id;
  final String name;
  final String collectionId;
  final String collection;
  final List<String> images;
  final List<ProductSizeModel> sizes;
  final String longevity;
  final String sillage;
  final String rate;
  final String reviewCount;
  final String description;
  final List<String> howToUse;
  final FragranceNotesModel notes;
  final List<dynamic> reviewList;

  const ProductDetailsModel({
    required this.id,
    required this.name,
    required this.collectionId,
    required this.collection,
    required this.images,
    required this.sizes,
    required this.longevity,
    required this.sillage,
    required this.rate,
    required this.reviewCount,
    required this.description,
    required this.howToUse,
    required this.notes,
    required this.reviewList,
  });

  factory ProductDetailsModel.empty() {
    return ProductDetailsModel(
      id: '',
      name: 'Product name here',
      collectionId: '',
      collection: '',
      images: const ['', ''],
      sizes: const [
        ProductSizeModel(
          id: '',
          value: '100',
          unit: 'ml',
          price: '000',
          discountPrice: '000',
          discountPercentage: '0',
          inStock: '1',
        ),
      ],
      longevity: 'Long lasting',
      sillage: 'Moderate',
      rate: '0',
      reviewCount: '0',
      description: 'Placeholder description text',
      howToUse: const ['Placeholder step one'],
      notes: FragranceNotesModel.empty(),
      reviewList: const [],
    );
  }

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    // Support both wrapped and unwrapped responses.
    final data = _asMap(json['data']).isNotEmpty
        ? _asMap(json['data'])
        : json;

    final rawSizes = _asList(data['sizes']);

    final sizes = rawSizes
        .whereType<Map>()
        .map(
          (item) => ProductSizeModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();

    final rawImages = _asList(data['images']);

    final images = rawImages.isNotEmpty
        ? rawImages.map((item) => item.toString()).toList()
        : data['image'] != null
            ? [data['image'].toString()]
            : <String>[];

    return ProductDetailsModel(
      id: _toStringValue(data['id']),
      name: _toStringValue(data['name']),
      collectionId: _toStringValue(data['collection_id']),
      collection: _toStringValue(data['collection']),
      images: images,
      sizes: sizes,
      longevity: _toStringValue(data['longevity']),
      sillage: _toStringValue(data['sillage']),
      rate: _toStringValue(data['rating'], '0'),
      reviewCount: _toStringValue(data['reviews'], '0'),
      description: _toStringValue(data['description']),
      howToUse: _asList(data['how_to_use'])
          .map((item) => item.toString())
          .toList(),
      notes: FragranceNotesModel.fromJson(
        _asMap(data['notes']),
      ),
      reviewList: _asList(data['review_list']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'collection_id': collectionId,
      'collection': collection,
      'images': images,
      'sizes': sizes.map((item) => item.toJson()).toList(),
      'longevity': longevity,
      'sillage': sillage,
      'rating': rate,
      'reviews': reviewCount,
      'description': description,
      'how_to_use': howToUse,
      'notes': notes.toJson(),
      'review_list': reviewList,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    collectionId,
    collection,
    images,
    sizes,
    longevity,
    sillage,
    rate,
    reviewCount,
    description,
    howToUse,
    notes,
    reviewList,
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
  final String status;

  const ProductSizeModel({
    required this.id,
    required this.value,
    required this.unit,
    required this.discountPrice,
    this.price,
    this.discountPercentage,
    required this.inStock,
    this.status = '',
  });

  factory ProductSizeModel.fromJson(Map<String, dynamic> json) {
    final originalPrice = json['price'] ?? 0;
    final discountedPrice = json['price_after'] ?? originalPrice;

    return ProductSizeModel(
      id: _toStringValue(json['id']),
      value: _toStringValue(
        json['value'] ?? json['label']?.toString().replaceAll(
          RegExp(r'[^0-9.]'),
          '',
        ),
      ),
      unit: _toStringValue(json['unit'], 'ml'),
      price: originalPrice.toString(),
      discountPrice: discountedPrice.toString(),
      discountPercentage: _toStringValue(
        json['discount_percent'] ?? json['discount_percentage'],
        '0',
      ),
      inStock: _toStringValue(
        json['quantity'] ?? json['in_stock'],
        '0',
      ),
      status: _toStringValue(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'unit': unit,
      'price': price,
      'price_after': discountPrice,
      'discount_percent': discountPercentage,
      'quantity': inStock,
      'status': status,
    };
  }

  bool get isAvailable => (int.tryParse(inStock ?? '0') ?? 0) > 0;

  bool get isLastFew => status == 'last_few';

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
    status,
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
            (item) => FragranceNoteModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    }

    return FragranceNotesModel(
      topNotes: parse(json['top'] ?? json['top_notes']),
      heartNotes: parse(json['heart'] ?? json['heart_notes']),
      baseNotes: parse(json['base'] ?? json['base_notes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'top': topNotes.map((item) => item.toJson()).toList(),
      'heart': heartNotes.map((item) => item.toJson()).toList(),
      'base': baseNotes.map((item) => item.toJson()).toList(),
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
    return const FragranceNoteModel(
      id: 0,
      name: 'Note',
      image: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }

  @override
  List<Object?> get props => [id, name, image];
}
