import 'cart_item_model.dart';
import 'cart_summary_model.dart';

/// رد الـ API كله: العناصر + العدد + الأرقام
class CartModel {
  final List<CartItemModel> items;
  final int itemCount;
  final CartSummaryModel summary;

  const CartModel({
    required this.items,
    required this.itemCount,
    required this.summary,
  });

  /// بيقبل الـ body كامل (`{data: {...}}`) أو الـ data نفسها
  factory CartModel.fromApi(Map<String, dynamic> body) {
    final raw = body['data'];
    final data = raw is Map ? Map<String, dynamic>.from(raw) : body;

    final list = data['items'];
    final items = list is List
        ? list
              .whereType<Map>()
              .map((e) => CartItemModel.fromApi(Map<String, dynamic>.from(e)))
              .toList()
        : <CartItemModel>[];

    final count = data['item_count'];
    return CartModel(
      items: items,
      itemCount: count is num ? count.toInt() : items.length,
      summary: CartSummaryModel.fromApi(data),
    );
  }

  static bool looksLikeCart(Map<String, dynamic> body) {
    final raw = body['data'];
    final data = raw is Map ? raw : body;
    return data['items'] is List;
  }
}