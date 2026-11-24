import 'package:equatable/equatable.dart';

num _num(dynamic v) => v is num ? v : (num.tryParse('${v ?? ''}') ?? 0);
String _str(dynamic v) => v?.toString() ?? '';

enum RefundStatus {
  requested,
  approved,
  rejected,
  refunded;

  static RefundStatus from(String? raw) {
    final value = raw?.trim().toLowerCase();
    for (final s in RefundStatus.values) {
      if (s.name == value) return s;
    }
    return RefundStatus.requested;
  }
}

/// order = مبلغ على الأوردر كله، items = منتجات محددة من بنوده
enum RefundScope {
  order,
  items;

  static RefundScope from(String? raw) =>
      raw?.trim().toLowerCase() == 'items' ? items : order;
}

/// بند اتختار في طلب إرجاع (اللي بيتبعت للسيرفر: id البند + الكمية بس)
class RefundItemSelection extends Equatable {
  final int orderItemId;
  final int quantity;

  const RefundItemSelection({required this.orderItemId, required this.quantity});

  Map<String, dynamic> toJson() => {
    'order_item_id': orderItemId,
    'quantity': quantity,
  };

  @override
  List<Object?> get props => [orderItemId, quantity];
}

/// سطر منتج جوه طلب إرجاع (`lines`). فاضية لو الطلب كان مبلغ على الأوردر.
class RefundLine extends Equatable {
  final int orderItemId;
  final String productName;
  final String size;
  final int quantity;
  final int unitPrice;
  final int amount;

  const RefundLine({
    required this.orderItemId,
    required this.productName,
    required this.size,
    required this.quantity,
    required this.unitPrice,
    required this.amount,
  });

  factory RefundLine.fromJson(Map<String, dynamic> j) => RefundLine(
    orderItemId: int.tryParse(_str(j['order_item_id'])) ?? 0,
    productName: _str(j['product_name']),
    size: _str(j['size']),
    quantity: int.tryParse(_str(j['quantity'])) ?? 1,
    unitPrice: _num(j['unit_price']).toInt(),
    amount: _num(j['amount']).toInt(),
  );

  @override
  List<Object?> get props => [
    orderItemId,
    productName,
    size,
    quantity,
    unitPrice,
    amount,
  ];
}

/// طلب إرجاع واحد (نفس شكل رد POST /orders/{id}/refunds)
class RefundModel extends Equatable {
  final int id;
  final int orderId;
  final int amount;
  final RefundScope scope;
  final List<RefundLine> lines;
  final String reason;
  final RefundStatus status;

  /// ملاحظة الموظفين (مش نص اليوزر)
  final String note;
  final DateTime createdAt;

  const RefundModel({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.scope,
    required this.lines,
    required this.reason,
    required this.status,
    required this.note,
    required this.createdAt,
  });

  factory RefundModel.fromJson(Map<String, dynamic> j) {
    final rawLines = j['lines'];
    return RefundModel(
      id: int.tryParse(_str(j['id'])) ?? 0,
      orderId: int.tryParse(_str(j['order_id'])) ?? 0,
      amount: _num(j['amount']).toInt(),
      scope: RefundScope.from(_str(j['scope'])),
      lines: (rawLines is List ? rawLines : const [])
          .whereType<Map>()
          .map((e) => RefundLine.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      reason: _str(j['reason']),
      status: RefundStatus.from(_str(j['status'])),
      note: _str(j['note']),
      createdAt:
          DateTime.tryParse(_str(j['created_at']))?.toLocal() ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    orderId,
    amount,
    scope,
    lines,
    reason,
    status,
    note,
    createdAt,
  ];
}

/// بيانات الإرجاع اللي جوه `data.refund` في تفاصيل الأوردر
class OrderRefundInfo extends Equatable {
  final bool canRequest;

  /// فلوس (مش قطع): إجمالي الطلب ناقص الطلبات requested/approved/refunded
  final int refundable;

  /// كل طلبات الإرجاع السابقة (الأحدث الأول)
  final List<RefundModel> items;

  const OrderRefundInfo({
    this.canRequest = false,
    this.refundable = 0,
    this.items = const [],
  });

  factory OrderRefundInfo.fromJson(Map<String, dynamic> j) {
    final raw = j['items'];
    final items =
        (raw is List ? raw : const [])
            .whereType<Map>()
            .map((e) => RefundModel.fromJson(Map<String, dynamic>.from(e)))
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return OrderRefundInfo(
      canRequest: j['can_request'] == true,
      refundable: _num(j['refundable']).toInt(),
      items: items,
    );
  }

  @override
  List<Object?> get props => [canRequest, refundable, items];
}

/// آخر طلب إرجاع على الأوردر في قايمة الأوردرات (`refund` في GET /orders).
/// null = مفيش طلب، والبادج بيتخفى.
class OrderRefundSummary extends Equatable {
  final int id;
  final RefundStatus status;
  final RefundScope scope;
  final int amount;

  const OrderRefundSummary({
    required this.id,
    required this.status,
    required this.scope,
    required this.amount,
  });

  factory OrderRefundSummary.fromJson(Map<String, dynamic> j) =>
      OrderRefundSummary(
        id: int.tryParse(_str(j['id'])) ?? 0,
        status: RefundStatus.from(_str(j['status'])),
        scope: RefundScope.from(_str(j['scope'])),
        amount: _num(j['amount']).toInt(),
      );

  @override
  List<Object?> get props => [id, status, scope, amount];
}