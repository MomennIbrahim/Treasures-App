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

/// طلب إرجاع واحد (نفس شكل رد POST /orders/{id}/refunds)
class RefundModel extends Equatable {
  final int id;
  final int orderId;
  final int amount;
  final String reason;
  final RefundStatus status;

  /// ملاحظة الموظفين (مش نص اليوزر)
  final String note;
  final DateTime createdAt;

  const RefundModel({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.reason,
    required this.status,
    required this.note,
    required this.createdAt,
  });

  factory RefundModel.fromJson(Map<String, dynamic> j) => RefundModel(
    id: int.tryParse(_str(j['id'])) ?? 0,
    orderId: int.tryParse(_str(j['order_id'])) ?? 0,
    amount: _num(j['amount']).toInt(),
    reason: _str(j['reason']),
    status: RefundStatus.from(_str(j['status'])),
    note: _str(j['note']),
    createdAt:
        DateTime.tryParse(_str(j['created_at']))?.toLocal() ?? DateTime.now(),
  );

  @override
  List<Object?> get props => [id, orderId, amount, reason, status, note, createdAt];
}

/// بيانات الإرجاع اللي جوه `data.refund` في تفاصيل الأوردر
class OrderRefundInfo extends Equatable {
  final bool canRequest;

  /// المتبقي اللي ينفع يتطلب إرجاعه
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