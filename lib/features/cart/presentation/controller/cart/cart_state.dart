part of 'cart_cubit.dart';

enum CartStatus { initial, loading, success, failure }
 
enum CartActionStatus { idle, loading, success, failure }
 
enum CartAction { add, update, remove }

 
class CartState {
  final CartStatus status; // تحميل السلة
  final AppFailure? failure;
  final List<CartItemModel> items;
 
  final CartActionStatus actionStatus; // العمليات
  final CartAction? action;
  final AppFailure? actionFailure;
 
  /// عدد الأصناف (للـ badge)
  final int count;
 
  /// ملخص الطلب من السيرفر (null لحد ما أول رد يجي)
  final CartSummaryModel? summary;
 
  const CartState({
    this.status = CartStatus.initial,
    this.failure,
    this.items = const [],
    this.actionStatus = CartActionStatus.idle,
    this.action,
    this.actionFailure,
    this.count = 0,
    this.summary,
  });
 
  // محسوبين
  num get subtotal => items.fold<num>(0, (s, i) => s + i.total);
  int get itemsCount => items.fold<int>(0, (s, i) => s + i.quantity);
  bool get isEmpty => items.isEmpty;
  bool get hasStockIssue => items.any((i) => !i.isAvailable || i.exceedsStock);
 
  bool get isLoading => status == CartStatus.loading;
  bool get isFailure => status == CartStatus.failure;
  bool get isAdding =>
      actionStatus == CartActionStatus.loading && action == CartAction.add;
 
  // failure / actionFailure بيتصفّروا عن قصد لو متبعتوش
  CartState copyWith({
    CartStatus? status,
    AppFailure? failure,
    List<CartItemModel>? items,
    CartActionStatus? actionStatus,
    CartAction? action,
    AppFailure? actionFailure,
    int? count,
    CartSummaryModel? summary,
  }) {
    return CartState(
      status: status ?? this.status,
      failure: failure,
      items: items ?? this.items,
      actionStatus: actionStatus ?? this.actionStatus,
      action: action ?? this.action,
      actionFailure: actionFailure,
      count: count ?? this.count,
      summary: summary ?? this.summary,
    );
  }
}
 