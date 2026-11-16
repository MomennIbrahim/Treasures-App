class CartSummaryModel {
  final num subtotal;
  final num? shipping;
  final num? tax;
  final num discount;
  final num? total;

  const CartSummaryModel({
    required this.subtotal,
    this.shipping,
    this.tax,
    this.discount = 0,
    this.total,
  });

  /// من الـ API: cost / shipping / tax / total
  factory CartSummaryModel.fromApi(Map<String, dynamic> json) {
    return CartSummaryModel(
      subtotal: _n(json['cost']) ?? 0,
      shipping: _n(json['shipping']),
      tax: _n(json['tax']),
      discount: _n(json['discount']) ?? 0,
      total: _n(json['total']),
    );
  }

  /// fallback لو لسه مفيش رد من السيرفر
  factory CartSummaryModel.fromSubtotal(num subtotal) =>
      CartSummaryModel(subtotal: subtotal);

  /// للـ Skeletonizer
  factory CartSummaryModel.empty() => const CartSummaryModel(
    subtotal: 100,
    shipping: 35,
    tax: 10,
    discount: 0,
    total: 145,
  );

  num get grandTotal =>
      total ?? (subtotal + (shipping ?? 0) + (tax ?? 0) - discount);

  static num? _n(dynamic v) => v == null ? null : (v is num ? v : num.tryParse('$v'));
}