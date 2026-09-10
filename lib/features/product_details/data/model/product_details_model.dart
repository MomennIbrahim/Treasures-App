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
    required this.description,
    this.howToUse,
    required this.notes,
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
      notes: FragranceNotesModel.fromJson(
        json['notes'] as Map<String, dynamic>? ?? {},
      ),
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

// ─────────────────────────────────────────────
// How To Use
// ─────────────────────────────────────────────

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
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image': image};
  }

  @override
  List<Object?> get props => [id, name, image];
}
