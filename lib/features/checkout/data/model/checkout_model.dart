// features/checkout/data/model/checkout_model.dart
 
import 'package:konoz/features/profile/data/model/profile_model.dart';

num _num(dynamic v) => v is num ? v : (num.tryParse('$v') ?? 0);

Map<String, dynamic> _unwrap(dynamic body) {
  if (body is Map && body['data'] is Map) {
    return Map<String, dynamic>.from(body['data'] as Map);
  }
  return Map<String, dynamic>.from(body as Map);
}

class PaymentMethodModel {
  final String id; // cod | card  ← ده اللي بيتبعت في payment_method
  final String name;
  final String detail;

  const PaymentMethodModel({
    required this.id,
    required this.name,
    required this.detail,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      PaymentMethodModel(
        id: '${json['id']}',
        name: '${json['name'] ?? ''}',
        detail: '${json['detail'] ?? ''}',
      );

  bool get isCash => id == 'cod';
}

class CheckoutModel {
  final String customerName;
  final String customerPhone;
  final bool needsAddress;
  final AddressModel? address;
  final List<AddressModel> addresses;
  final List<PaymentMethodModel> payments;
  final num subtotal;
  final num shipping;
  final num tax;
  final num total;

  const CheckoutModel({
    required this.customerName,
    required this.customerPhone,
    required this.needsAddress,
    required this.address,
    required this.addresses,
    required this.payments,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
  });

  factory CheckoutModel.fromJson(Map<String, dynamic> json) {
    final customer = json['customer'] is Map
        ? Map<String, dynamic>.from(json['customer'] as Map)
        : const <String, dynamic>{};
    final addrs = (json['addresses'] as List? ?? [])
        .map((e) => AddressModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    final pays = (json['payments'] as List? ?? [])
        .map((e) =>
            PaymentMethodModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();

    return CheckoutModel(
      customerName: '${customer['name'] ?? ''}',
      customerPhone: '${customer['phone'] ?? ''}',
      needsAddress: json['needs_address'] == true,
      address: json['address'] is Map
          ? AddressModel.fromJson(
              Map<String, dynamic>.from(json['address'] as Map))
          : null,
      addresses: addrs,
      payments: pays,
      subtotal: _num(json['cost']),
      shipping: _num(json['shipping']),
      tax: _num(json['tax']),
      total: _num(json['total']),
    );
  }

  factory CheckoutModel.fromBody(dynamic body) =>
      CheckoutModel.fromJson(_unwrap(body));
}

class PlacedOrderModel {
  final int orderId;
  final num total;

  const PlacedOrderModel({required this.orderId, required this.total});

  factory PlacedOrderModel.fromJson(Map<String, dynamic> json) =>
      PlacedOrderModel(
        orderId: int.tryParse('${json['order_id']}') ?? 0,
        total: _num(json['total']),
      );

  factory PlacedOrderModel.fromBody(dynamic body) =>
      PlacedOrderModel.fromJson(_unwrap(body));
}