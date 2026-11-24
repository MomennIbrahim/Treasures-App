// features/orders/data/model/order_model.dart
import 'package:equatable/equatable.dart';
import 'package:konoz/features/order_details/data/model/refund_model.dart';

enum OrderStatus {
  pending,
  confirmed,
  shipped,
  delivered,
  cancelled;

  static OrderStatus from(String? raw) {
    final value = raw?.trim().toLowerCase();
    for (final s in OrderStatus.values) {
      if (s.name == value) return s;
    }
    return OrderStatus.pending;
  }

  /// الإلغاء مسموح قبل الشحن بس (بعد كده مرتجعات).
  /// السيرفر هو المرجع النهائي لو الحالة اتغيرت في الأثناء.
  bool get canCancel =>
      this == OrderStatus.pending || this == OrderStatus.confirmed;
}

class OrderItemModel extends Equatable {
  final String name;
  final String image;
  final int quantity;

  const OrderItemModel({
    required this.name,
    required this.image,
    required this.quantity,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      name: json['product_name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      quantity: int.tryParse(json['quantity']?.toString() ?? '') ?? 1,
    );
  }

  @override
  List<Object?> get props => [name, image, quantity];
}

class OrderModel extends Equatable {
  final int id;
  final OrderStatus status;
  final double total;
  final DateTime createdAt;
  final List<OrderItemModel> items;

  /// آخر طلب إرجاع على الأوردر (null = مفيش، والبادج بيتخفى).
  /// حالة التوصيل بتفضل في [status] (Delivered ما بيتبدلش).
  final OrderRefundSummary? refund;

  const OrderModel({
    required this.id,
    required this.status,
    required this.total,
    required this.createdAt,
    required this.items,
    this.refund,
  });

  // للـ skeleton وقت التحميل فقط
  factory OrderModel.empty() => OrderModel(
    id: 0,
    status: OrderStatus.pending,
    total: 0,
    createdAt: DateTime(2026),
    items: const [
      OrderItemModel(name: 'Product name here', image: '', quantity: 1),
    ],
  );

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // الـ API بيرجّع `items`، والـ fallback للشكل القديم
    final raw = json['items'] ?? json['order_items'];
    final items = (raw is List ? raw : const [])
        .whereType<Map>()
        .map((e) => OrderItemModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    final refundJson = json['refund'];

    return OrderModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      status: OrderStatus.from(json['status']?.toString()),
      total: double.tryParse(json['total']?.toString() ?? '') ?? 0,
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '')?.toLocal() ??
          DateTime.now(),
      items: items,
      refund: refundJson is Map
          ? OrderRefundSummary.fromJson(Map<String, dynamic>.from(refundJson))
          : null,
    );
  }

  OrderModel copyWith({OrderStatus? status}) => OrderModel(
    id: id,
    status: status ?? this.status,
    total: total,
    createdAt: createdAt,
    items: items,
    refund: refund,
  );

  bool get canCancel => status.canCancel;

  String get image => items.isEmpty ? '' : items.first.image;

  String get totalLabel =>
      total % 1 == 0 ? total.toStringAsFixed(0) : total.toStringAsFixed(2);

  String get dateLabel =>
      '${createdAt.day}/${createdAt.month}/${createdAt.year}';

  /// للسيرش: رقم الأوردر أو اسم أي منتج فيه
  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    if (id.toString().contains(q)) return true;
    return items.any((i) => i.name.toLowerCase().contains(q));
  }

  @override
  List<Object?> get props => [id, status, total, createdAt, items, refund];
}