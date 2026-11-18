/// محتوى الباكدج (منتج جوه الباكدج)
class CartPackageContentModel {
  final String productId;
  final String name;
  final String image;
  final String size;
  final int quantity;

  const CartPackageContentModel({
    required this.productId,
    required this.name,
    required this.image,
    required this.size,
    required this.quantity,
  });

  factory CartPackageContentModel.fromApi(Map<String, dynamic> json) {
    final q = json['quantity'];
    return CartPackageContentModel(
      productId: json['product_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      size: json['size']?.toString() ?? '',
      quantity: q is num ? q.toInt() : 1,
    );
  }
}

class CartItemModel {
  final int id;
  final String type; // "product" | "package"
  final String? productId; // للمنتج العادي
  final String? packageId; // للباكدج (الـ ULID مش الـ id الرقمي)
  final String name;
  final String image;
  final String sizeLabel;
  final double unitPrice;
  final int quantity;
  final double total;
  final bool isAvailable;
  final int inStock;
  final List<CartPackageContentModel> packageItems;

  const CartItemModel({
    required this.id,
    required this.type,
    this.productId,
    this.packageId,
    required this.name,
    required this.image,
    required this.sizeLabel,
    required this.unitPrice,
    required this.quantity,
    required this.total,
    required this.isAvailable,
    required this.inStock,
    this.packageItems = const [],
  });

  /// بتتحسب من الكمية والمخزون، فتفضل صح بعد copyWith
  bool get exceedsStock => quantity > inStock;
  bool get canIncrease => quantity < inStock;

  CartItemModel copyWith({
    int? id,
    String? type,
    String? productId,
    String? packageId,
    String? name,
    String? image,
    String? sizeLabel,
    double? unitPrice,
    int? quantity,
    double? total,
    bool? isAvailable,
    int? inStock,
    List<CartPackageContentModel>? packageItems,
  }) {
    final newUnitPrice = unitPrice ?? this.unitPrice;
    final newQuantity = quantity ?? this.quantity;
    return CartItemModel(
      id: id ?? this.id,
      type: type ?? this.type,
      productId: productId ?? this.productId,
      packageId: packageId ?? this.packageId,
      name: name ?? this.name,
      image: image ?? this.image,
      sizeLabel: sizeLabel ?? this.sizeLabel,
      unitPrice: newUnitPrice,
      quantity: newQuantity,
      // لو الكمية اتغيرت والـ total مش متبعت، نحسبه من جديد
      total: total ?? newUnitPrice * newQuantity,
      isAvailable: isAvailable ?? this.isAvailable,
      inStock: inStock ?? this.inStock,
      packageItems: packageItems ?? this.packageItems,
    );
  }

  factory CartItemModel.empty() => const CartItemModel(
    id: 0,
    type: 'product',
    name: 'Loading product name',
    image: '',
    sizeLabel: '50 ml',
    unitPrice: 0,
    quantity: 1,
    total: 0,
    isAvailable: true,
    inStock: 999,
    packageItems: [],
  );

  factory CartItemModel.fromApi(Map<String, dynamic> json) {
    double num_(dynamic v) => v is num ? v.toDouble() : 0;
    final type = json['type']?.toString() ?? 'product';
    final isPackage = type == 'package';
    final quantity = json['quantity'] is num
        ? (json['quantity'] as num).toInt()
        : 1;
    final unitPrice = num_(json['price'] ?? json['unit_price']);

    // الباكدج مفيهوش stock في الـ API، فبنعتبره متاح (999) عشان ما يتحسبش خلصان
    final rawStock = json['in_stock'] ?? json['stock'];
    final inStock = rawStock is num ? rawStock.toInt() : 999;

    final rawItems = json['items'];
    final packageItems = (isPackage && rawItems is List)
        ? rawItems
              .whereType<Map>()
              .map(
                (e) => CartPackageContentModel.fromApi(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList()
        : <CartPackageContentModel>[];

    return CartItemModel(
      id: json['id'] is num ? (json['id'] as num).toInt() : 0,
      type: type,
      productId: json['product_id']?.toString(),
      packageId: json['package_id']?.toString(),
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      sizeLabel: json['size']?.toString() ?? '',
      unitPrice: unitPrice,
      quantity: quantity,
      total: json['total'] is num ? num_(json['total']) : unitPrice * quantity,
      isAvailable: json['is_available'] ?? json['available'] ?? true,
      inStock: inStock,
      packageItems: packageItems,
    );
  }
}