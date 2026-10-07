class CartSummaryModel {
  final num subtotal;
  final num? shipping; // null = لسه مجبناش الأرقام من السيرفر
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

  /// لو total مش موجود نرجع للـ subtotal
  num get grandTotal => total ?? subtotal;

  factory CartSummaryModel.fromJson(Map<String, dynamic> json) {
    return CartSummaryModel(
      subtotal: _toNum(json['subtotal']),
      shipping: _toNum(json['shipping']),
      tax: _toNum(json['tax']),
      discount: _toNum(json['discount']),
      total: _toNum(json['total']),
    );
  }

  /// fallback لو فشل جلب الملخص: بنعرض الـ subtotal بس
  factory CartSummaryModel.fromSubtotal(num subtotal) =>
      CartSummaryModel(subtotal: subtotal);

  /// للـ skeleton وقت التحميل فقط
  factory CartSummaryModel.empty() => const CartSummaryModel(
        subtotal: 5000,
        shipping: 35,
        tax: 500,
        discount: 0,
        total: 5535,
      );
}

num _toNum(dynamic v) => v is num ? v : (num.tryParse('$v') ?? 0);
