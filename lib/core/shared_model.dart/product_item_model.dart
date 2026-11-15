/// بطاقة المنتج المختصرة، بترجع من:
/// /trending و /top-sellers و /products و داخل /products/{id}
class ProductItemModel {
  final String id;
  final String name;
  final String collectionId;
  final String collection;
  final double rating;
  final int reviews;
  final String longevity;
  final String sillage;
  final String? image;
  final int fromPrice;
  final List<ProductSizeModel> sizes;

  const ProductItemModel({
    required this.id,
    required this.name,
    required this.collectionId,
    required this.collection,
    required this.rating,
    required this.reviews,
    required this.longevity,
    required this.sillage,
    required this.image,
    required this.fromPrice,
    required this.sizes,
  });

  factory ProductItemModel.fromApi(Map<String, dynamic> json) {
    final sizes = (json['sizes'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(ProductSizeModel.fromJson)
        .toList();

    return ProductItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      collectionId: json['collection_id']?.toString() ?? '',
      collection: json['collection']?.toString() ?? '',
      rating: _toDouble(json['rating']),
      reviews: _toInt(json['reviews']),
      longevity: json['longevity']?.toString() ?? '',
      sillage: json['sillage']?.toString() ?? '',
      image: json['image']?.toString(),
      fromPrice: _toInt(json['from_price']),
      sizes: sizes,
    );
  }

  factory ProductItemModel.fromJson(Map<String, dynamic> json) =>
      ProductItemModel.fromApi(json);

  /// بيانات وهمية للـ Skeletonizer. النصوص بطول معقول عشان شكل الـ skeleton
  /// يطلع قريب من الشكل الحقيقي.
  factory ProductItemModel.empty() => const ProductItemModel(
        id: '',
        name: 'Product name here',
        collectionId: '',
        collection: 'Collection',
        rating: 0,
        reviews: 0,
        longevity: '12+',
        sillage: 'High',
        image: null,
        fromPrice: 999,
        sizes: [
          ProductSizeModel(
            label: '50 ml',
            price: 999,
            discountPercent: 0,
            priceAfter: 999,
            quantity: 1,
            status: 'available',
          ),
        ],
      );

  /// أول مقاس متاح للبيع، أو null لو كله خلص.
  ProductSizeModel? get firstAvailableSize {
    for (final size in sizes) {
      if (size.isSellable) return size;
    }
    return null;
  }

  /// فيه أي مقاس عليه خصم؟
  bool get hasDiscount => sizes.any((size) => size.discountPercent > 0);

  /// كل المقاسات خلصت.
  bool get isOutOfStock => sizes.isNotEmpty && firstAvailableSize == null;

  static int _toInt(dynamic value) =>
      value is num ? value.toInt() : int.tryParse('$value') ?? 0;

  static double _toDouble(dynamic value) =>
      value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
}

/// مقاس واحد للمنتج. label مثل "50 ml" وهو نفس القيمة اللي بتتبعت للسلة.
class ProductSizeModel {
  final String label;
  final int price;
  final int discountPercent;
  final int priceAfter;
  final int quantity;

  /// available | one_last | last_few | out_of_stock | soon
  final String status;

  const ProductSizeModel({
    required this.label,
    required this.price,
    required this.discountPercent,
    required this.priceAfter,
    required this.quantity,
    required this.status,
  });

  factory ProductSizeModel.fromJson(Map<String, dynamic> json) {
    return ProductSizeModel(
      label: json['label']?.toString() ?? '',
      price: ProductItemModel._toInt(json['price']),
      discountPercent: ProductItemModel._toInt(json['discount_percent']),
      priceAfter: ProductItemModel._toInt(json['price_after']),
      quantity: ProductItemModel._toInt(json['quantity']),
      status: json['status']?.toString() ?? '',
    );
  }

  /// قابل للبيع: أي حالة غير out_of_stock و soon.
  /// (السيرفر بيرجع last_few في الرد الفعلي، والتوثيق كاتبها few_last.)
  bool get isSellable =>
      quantity > 0 && status != 'out_of_stock' && status != 'soon';

  bool get hasDiscount => discountPercent > 0;
}