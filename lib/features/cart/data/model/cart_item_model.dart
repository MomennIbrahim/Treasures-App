class CartItemModel {
  final int id;
  final String productId; // ULID
  final String name; // بيجي شامل المقاس: "Vanilla Powder 30 ml"
  final String image; // '' لو مفيش صورة
  final num unitPrice;
  final int quantity;
  final int inStock;

  /// in_stock | last_few | out_of_stock | soon
  final String status;

  const CartItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.image,
    required this.unitPrice,
    required this.quantity,
    required this.inStock,
    required this.status,
  });

  factory CartItemModel.fromApi(Map<String, dynamic> json) {
    return CartItemModel(
      id: _toInt(json['id']),
      productId: (json['product_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      unitPrice: _toNum(json['price']),
      quantity: _toInt(json['quantity'], fallback: 1),
      inStock: _toInt(json['stock']),
      status: (json['status'] ?? '').toString(),
    );
  }

  /// للـ Skeletonizer
  factory CartItemModel.empty() => const CartItemModel(
    id: 0,
    productId: '',
    name: 'Product name 50 ml',
    image: '',
    unitPrice: 100,
    quantity: 1,
    inStock: 10,
    status: 'in_stock',
  );

  static final _sizeRegex = RegExp(
    r'(\d+(?:\.\d+)?\s*ml)\s*$',
    caseSensitive: false,
  );

  /// الـ API مش بيرجّع المقاس لوحده، فبنطلعه من آخر الاسم ("30 ml")
  String get sizeLabel => _sizeRegex.firstMatch(name)?.group(1) ?? '';

  num get total => unitPrice * quantity;

  bool get isAvailable =>
      inStock > 0 && status != 'out_of_stock' && status != 'soon';
  bool get exceedsStock => quantity > inStock;
  bool get canIncrease => isAvailable && quantity < inStock;

  CartItemModel copyWith({int? quantity}) => CartItemModel(
    id: id,
    productId: productId,
    name: name,
    image: image,
    unitPrice: unitPrice,
    quantity: quantity ?? this.quantity,
    inStock: inStock,
    status: status,
  );

  static int _toInt(dynamic v, {int fallback = 0}) =>
      v is int ? v : (v is num ? v.toInt() : int.tryParse('$v') ?? fallback);

  static num _toNum(dynamic v) => v is num ? v : (num.tryParse('$v') ?? 0);
}