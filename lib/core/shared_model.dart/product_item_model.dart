class ProductItemModel {
  final int id;
  final String name;
  final String description;
  final String image;

  final String price;
  final String? discountPrice;
  final String? discountPercentage;

  final String rating;
  final String reviewCount;

  final bool inStock;

  final List<ProductSizeModel> sizes;

  const ProductItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.discountPrice,
    required this.discountPercentage,
    required this.rating,
    required this.reviewCount,
    required this.inStock,
    required this.sizes,
  });

  factory ProductItemModel.empty() {
    return const ProductItemModel(
      id: 0,
      name: 'placeholder name',
      description: 'placeholder description text here',
      image:
          'https://i.pinimg.com/736x/91/46/b1/9146b1806b9cc89d22d12ccb987e0d5a.jpg',
      price: '000',
      discountPrice: null,
      discountPercentage: null,
      rating: '0.0',
      reviewCount: '00',
      inStock: true,
      sizes: [],
    );
  }

  factory ProductItemModel.fromJson(Map<String, dynamic> json) {
    return ProductItemModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      price: json['price'].toString(),
      discountPrice: json['discount_price']?.toString(),
      discountPercentage: json['discount_percentage'].toString(),
      rating: json['rating'].toString(),
      reviewCount: json['review_count'].toString(),
      inStock: json['in_stock'] == 1,
      sizes: (json['sizes'] as List<dynamic>? ?? [])
          .map((e) => ProductSizeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProductSizeModel {
  final int id;
  final String size; // "30 ml", "50 ml", "100 ml"

  const ProductSizeModel({required this.id, required this.size});

  factory ProductSizeModel.fromJson(Map<String, dynamic> json) {
    return ProductSizeModel(
      id: json['id'] as int,
      size: json['size'] as String,
    );
  }
}
