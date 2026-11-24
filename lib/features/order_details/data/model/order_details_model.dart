import 'package:equatable/equatable.dart';
import 'package:konoz/core/helper/date_format_helper.dart';
import 'package:konoz/features/order_details/data/model/refund_model.dart';
import 'package:konoz/features/orders/data/model/order_model.dart';

num _num(dynamic v) => v is num ? v : (num.tryParse('${v ?? ''}') ?? 0);
String _str(dynamic v) => v?.toString() ?? '';
Map<String, dynamic> _map(dynamic v) =>
    v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};

class OrderDetailsItem extends Equatable {
  /// id البند في الأوردر (اللي بيتبعت في طلب الإرجاع بالمنتجات)
  final int id;
  final String productId;
  final String name;
  final String size;
  final String image;
  final int quantity;
  final num unitPrice; // 0 لو الـ API مش بيرجّعه
  final num total;

  /// الكمية المتاحة للإرجاع (0 = مش بيظهر في اختيار المنتجات)
  final int refundableQuantity;

  const OrderDetailsItem({
    this.id = 0,
    this.productId = '',
    required this.name,
    this.size = '',
    required this.image,
    required this.quantity,
    required this.unitPrice,
    required this.total,
    this.refundableQuantity = 0,
  });

  factory OrderDetailsItem.fromJson(Map<String, dynamic> j) {
    final qty = int.tryParse(_str(j['quantity'])) ?? 1;
    final unit = _num(j['unit_price'] ?? j['price']);
    final total = j['total'] != null ? _num(j['total']) : unit * qty;
    return OrderDetailsItem(
      id: int.tryParse(_str(j['id'])) ?? 0,
      productId: _str(j['product_id'] ?? j['productId']),
      name: _str(j['product_name'] ?? j['name']),
      size: _str(j['size']),
      image: _str(j['image']),
      quantity: qty,
      unitPrice: unit,
      total: total,
      refundableQuantity: int.tryParse(_str(j['refundable_quantity'])) ?? 0,
    );
  }

  @override
  List<Object?> get props => [
    id,
    productId,
    name,
    size,
    image,
    quantity,
    unitPrice,
    total,
    refundableQuantity,
  ];
}

class OrderAmounts extends Equatable {
  final num subtotal;
  final num shipping;
  final num tax;
  final num discount;
  final num total;

  const OrderAmounts({
    this.subtotal = 0,
    this.shipping = 0,
    this.tax = 0,
    this.discount = 0,
    this.total = 0,
  });

  factory OrderAmounts.fromJson(Map<String, dynamic> j, {num? fallbackTotal}) =>
      OrderAmounts(
        subtotal: _num(j['subtotal'] ?? j['cost']),
        shipping: _num(j['shipping']),
        tax: _num(j['tax']),
        discount: _num(j['discount']),
        total: j['total'] != null ? _num(j['total']) : (fallbackTotal ?? 0),
      );

  @override
  List<Object?> get props => [subtotal, shipping, tax, discount, total];
}

class TrackingStep extends Equatable {
  final OrderStatus status;
  final DateTime? at;
  final bool done;

  const TrackingStep({required this.status, this.at, required this.done});

  @override
  List<Object?> get props => [status, at, done];
}

class OrderAddressInfo extends Equatable {
  final String title;
  final String fullAddress;

  const OrderAddressInfo({this.title = '', this.fullAddress = ''});

  bool get isEmpty => title.isEmpty && fullAddress.isEmpty;

  factory OrderAddressInfo.fromJson(Map<String, dynamic> j) => OrderAddressInfo(
    title: _str(j['title'] ?? j['address_title']),
    fullAddress: _str(j['fullAddress'] ?? j['full_address'] ?? j['address']),
  );

  @override
  List<Object?> get props => [title, fullAddress];
}

class OrderDetailsModel extends Equatable {
  final int id;
  final OrderStatus status;
  final DateTime createdAt;
  final String paymentMethod;
  final OrderAddressInfo address;
  final List<OrderDetailsItem> items;
  final OrderAmounts amounts;
  final List<TrackingStep> tracking;
  final OrderRefundInfo refund;

  const OrderDetailsModel({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.paymentMethod,
    required this.address,
    required this.items,
    required this.amounts,
    required this.tracking,
    this.refund = const OrderRefundInfo(),
  });

  String get dateLabel => DateFormatHelper.dayMonth(createdAt);

  /// للـ skeleton وقت التحميل فقط
  factory OrderDetailsModel.empty() => OrderDetailsModel(
    id: 0,
    status: OrderStatus.pending,
    createdAt: DateTime(2026),
    paymentMethod: 'cod',
    address: const OrderAddressInfo(
      title: 'Home',
      fullAddress: 'Street name, building number, city',
    ),
    items: const [
      OrderDetailsItem(
        name: 'Product name here 50 ml',
        image: '',
        quantity: 1,
        unitPrice: 100,
        total: 100,
      ),
      OrderDetailsItem(
        name: 'Product name here 30 ml',
        image: '',
        quantity: 1,
        unitPrice: 100,
        total: 100,
      ),
    ],
    amounts: const OrderAmounts(
      subtotal: 200,
      shipping: 35,
      tax: 20,
      total: 255,
    ),
    tracking: _derive(OrderStatus.pending, null),
  );

  factory OrderDetailsModel.fromBody(dynamic body) {
    final root = _map(body);
    final j = root['data'] is Map ? _map(root['data']) : root;

    final status = OrderStatus.from(_str(j['status']));
    final createdAt =
        DateTime.tryParse(_str(j['created_at']))?.toLocal() ?? DateTime.now();

    final rawItems = j['items'] ?? j['order_items'];
    final items = (rawItems is List ? rawItems : const [])
        .whereType<Map>()
        .map((e) => OrderDetailsItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    final amounts = OrderAmounts.fromJson(
      _map(j['amounts']),
      fallbackTotal: _num(j['total']),
    );

    // العنوان: كائن address، أو حقول مسطّحة على الأوردر
    final addrJson = j['address'] is Map
        ? _map(j['address'])
        : <String, dynamic>{
            'title': j['address_title'],
            'full_address': j['address_full'] ?? j['address'],
          };

    return OrderDetailsModel(
      id: int.tryParse(_str(j['id'])) ?? 0,
      status: status,
      createdAt: createdAt,
      paymentMethod: _str(j['payment_method'] ?? j['payment']),
      address: OrderAddressInfo.fromJson(addrJson),
      items: items,
      amounts: amounts,
      tracking: _parseTracking(j['tracking'], status, createdAt),
      refund: OrderRefundInfo.fromJson(_map(j['refund'])),
    );
  }

  static List<TrackingStep> _parseTracking(
    dynamic raw,
    OrderStatus current,
    DateTime createdAt,
  ) {
    if (raw is List && raw.isNotEmpty) {
      final steps = raw.whereType<Map>().map((e) {
        final m = Map<String, dynamic>.from(e);
        final at = DateTime.tryParse(
          _str(m['at'] ?? m['date'] ?? m['created_at']),
        )?.toLocal();
        final done = m['done'] ?? m['completed'] ?? m['reached'];
        return TrackingStep(
          status: OrderStatus.from(_str(m['status'] ?? m['key'] ?? m['step'])),
          at: at,
          done: done is bool ? done : at != null,
        );
      }).toList();
      if (steps.isNotEmpty) return steps;
    }
    return _derive(current, createdAt);
  }

  /// لو الـ API مرجّعش خطوات: نبنيها من الحالة الحالية
  static List<TrackingStep> _derive(OrderStatus current, DateTime? createdAt) {
    if (current == OrderStatus.cancelled) {
      return [
        TrackingStep(status: OrderStatus.pending, at: createdAt, done: true),
        const TrackingStep(status: OrderStatus.cancelled, done: true),
      ];
    }
    const flow = [
      OrderStatus.pending,
      OrderStatus.confirmed,
      OrderStatus.shipped,
      OrderStatus.delivered,
    ];
    final reached = flow.indexOf(current);
    return [
      for (var i = 0; i < flow.length; i++)
        TrackingStep(
          status: flow[i],
          at: i == 0 ? createdAt : null,
          done: i <= reached,
        ),
    ];
  }

  bool get isCash => paymentMethod.isEmpty || paymentMethod == 'cod';

  bool get canCancel => status.canCancel;

  /// الإرجاع بالمنتجات بس: لازم السيرفر يسمح (`can_request`) وفيه بند
  /// فيه كمية متاحة. لو الباقي بس شحن (من غير منتجات متاحة) الزرار بيتخفى.
  bool get canRequestRefund =>
      refund.canRequest &&
      items.any((i) => i.id != 0 && i.refundableQuantity > 0);

  @override
  List<Object?> get props => [
    id,
    status,
    createdAt,
    paymentMethod,
    address,
    items,
    amounts,
    tracking,
    refund,
  ];
}