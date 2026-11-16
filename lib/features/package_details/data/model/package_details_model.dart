import 'package:equatable/equatable.dart';

num _num(dynamic v) => v is num ? v : (num.tryParse('${v ?? ''}') ?? 0);
String _str(dynamic v) => v?.toString() ?? '';
Map<String, dynamic> _map(dynamic v) =>
    v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};

String _money(num n) => '${n % 1 == 0 ? n.toInt() : n.toStringAsFixed(2)} EGP';

/// منتج جوه الباكدج (من items في GET /packages/{id})
class PackageProductModel extends Equatable {
  final String id; // product_id (ULID)
  final String name;
  final String image;
  final String size; // "50 ml" ← ده نفس اللي السلة بتستقبله
  final int quantity;
  final num price;
  final num total;

  const PackageProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.size,
    required this.quantity,
    required this.price,
    required this.total,
  });

  factory PackageProductModel.fromJson(Map<String, dynamic> j) {
    final qty = int.tryParse(_str(j['quantity'])) ?? 1;
    final price = _num(j['price']);
    return PackageProductModel(
      id: _str(j['product_id'] ?? j['id']),
      name: _str(j['name']),
      image: _str(j['image']),
      size: _str(j['size']),
      quantity: qty,
      price: price,
      total: j['total'] != null ? _num(j['total']) : price * qty,
    );
  }

  /// "50 ml" أو "50 ml ×2"
  String get label => quantity > 1 ? '$size  ×$quantity' : size;

  @override
  List<Object?> get props => [id, name, image, size, quantity, price, total];
}

class PackageDetailsModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> howToUse;
  final num price;
  final List<String> images;
  final List<PackageProductModel> products;

  const PackageDetailsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.howToUse,
    required this.price,
    required this.images,
    required this.products,
  });

  /// للـ skeleton وقت التحميل فقط (images فاضية = placeholder في الهيدر)
  factory PackageDetailsModel.empty() => PackageDetailsModel(
    id: '',
    name: 'Package name goes here',
    description:
        'Package description goes here, a couple of lines of text to fill.',
    howToUse: const ['Spray on pulse points.', 'Keep the bottle away.'],
    price: 0,
    images: const [],
    products: List.generate(
      3,
      (i) => PackageProductModel(
        id: '$i',
        name: 'Product name',
        image: '',
        size: '50 ml',
        quantity: 1,
        price: 0,
        total: 0,
      ),
    ),
  );

  factory PackageDetailsModel.fromBody(dynamic body) {
    final root = _map(body);
    final j = root['data'] is Map ? _map(root['data']) : root;

    final products = (j['items'] is List ? j['items'] as List : const [])
        .whereType<Map>()
        .map((e) => PackageProductModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    final howToUse = (j['how_to_use'] is List ? j['how_to_use'] as List : const [])
        .map((e) => e.toString())
        .where((e) => e.trim().isNotEmpty)
        .toList();

    // صورة الباكدج (لو فيه) وبعدها صور منتجاته. الـ API ساعات بيرجّع image = null
    final images = <String>[
      if (_str(j['image']).isNotEmpty) _str(j['image']),
      ...products.map((p) => p.image).where((e) => e.isNotEmpty),
    ].toSet().toList();

    return PackageDetailsModel(
      id: _str(j['id']),
      name: _str(j['name']),
      description: _str(j['description']),
      howToUse: howToUse,
      price: _num(j['price']),
      images: images,
      products: products,
    );
  }

  String get priceLabel => _money(price);

  @override
  List<Object?> get props =>
      [id, name, description, howToUse, price, images, products];
}
