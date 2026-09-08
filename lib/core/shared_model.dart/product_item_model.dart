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
  });

  factory ProductItemModel.fromJson(Map<String, dynamic> json) {
    return ProductItemModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      price: json['price'].toString(),
      discountPrice: json['discount_price'].toString(),
      discountPercentage: json['discount_percentage'].toString(),
      rating: json['rating'].toString(),
      reviewCount: json['review_count'].toString(),
      inStock: json['in_stock'] == 1,
    );
  }
}