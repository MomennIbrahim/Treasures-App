class CartItemModel {
  final int id;
  final int sizeId;
  final int productId;
  final String name;
  final String image;
  final String sizeLabel;
  final num unitPrice;
  final int quantity;
  final int inStock;

  const CartItemModel({
    required this.id,
    required this.sizeId,
    required this.productId,
    required this.name,
    required this.image,
    required this.sizeLabel,
    required this.unitPrice,
    required this.quantity,
    required this.inStock,
  });

  num get total => unitPrice * quantity;
  bool get isAvailable => inStock > 0;
  bool get exceedsStock => quantity > inStock;
  bool get canIncrease => quantity < inStock;

  /// Row from: select('*, product_sizes(*, products(id, name, images))')
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final size = _asMap(json['product_sizes']);
    final product = _asMap(size['products']);
    final images = _asList(product['images']);

    final price = _toNum(size['price']);
    final discount = _toNum(size['discount_price']);

    return CartItemModel(
      id: _toInt(json['id']),
      sizeId: _toInt(json['size_id']),
      productId: _toInt(product['id']),
      name: product['name']?.toString() ?? '',
      image: images.isNotEmpty ? images.first.toString() : '',
      sizeLabel: '${size['value'] ?? ''} ${size['unit'] ?? ''}'.trim(),
      // السعر بعد الخصم لو موجود، وإلا السعر الأصلي
      unitPrice: discount > 0 ? discount : price,
      quantity: _toInt(json['quantity']),
      inStock: _toInt(size['in_stock']),
    );
  }

  CartItemModel copyWith({int? quantity}) => CartItemModel(
        id: id,
        sizeId: sizeId,
        productId: productId,
        name: name,
        image: image,
        sizeLabel: sizeLabel,
        unitPrice: unitPrice,
        quantity: quantity ?? this.quantity,
        inStock: inStock,
      );

  /// للـ Skeletonizer وقت التحميل فقط
  factory CartItemModel.empty() => const CartItemModel(
        id: 0,
        sizeId: 0,
        productId: 0,
        name: 'Product name loading',
        image: '',
        sizeLabel: '100 ml',
        unitPrice: 1000,
        quantity: 1,
        inStock: 10,
      );
}

Map<String, dynamic> _asMap(dynamic v) =>
    v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};

List _asList(dynamic v) => v is List ? v : const [];

int _toInt(dynamic v) =>
    v is int ? v : (v is num ? v.toInt() : int.tryParse('$v') ?? 0);

num _toNum(dynamic v) => v is num ? v : (num.tryParse('$v') ?? 0);
