part of 'checkout_cubit.dart';

enum CheckoutStatus { initial, loading, success, failure }

class CheckoutState {
  // إنشاء الأوردر
  final CheckoutStatus status;
  final AppFailure? failure;
  final PlacedOrderModel? order;

  // تحميل بيانات الـ checkout (GET /checkout)
  final CheckoutStatus loadStatus;
  final CheckoutModel? data;

  final int? selectedAddressId;
  final String? selectedPaymentId; // null = أول طريقة دفع

  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.failure,
    this.order,
    this.loadStatus = CheckoutStatus.initial,
    this.data,
    this.selectedAddressId,
    this.selectedPaymentId,
  });

  bool get isLoading => status == CheckoutStatus.loading;
  bool get isSuccess => status == CheckoutStatus.success;
  bool get isFailure => status == CheckoutStatus.failure;

  bool get isDataLoading => loadStatus == CheckoutStatus.loading;
  bool get isDataFailure => loadStatus == CheckoutStatus.failure;

  List<PaymentMethodModel> get payments => data?.payments ?? const [];

  /// المختار، وإلا أول طريقة متاحة، وإلا cod
  String get paymentMethod =>
      selectedPaymentId ??
      (payments.isNotEmpty ? payments.first.id : 'cod');

  // failure بيتصفّر عن قصد لو متبعتش
  CheckoutState copyWith({
    CheckoutStatus? status,
    AppFailure? failure,
    PlacedOrderModel? order,
    CheckoutStatus? loadStatus,
    CheckoutModel? data,
    int? selectedAddressId,
    String? selectedPaymentId,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      failure: failure,
      order: order ?? this.order,
      loadStatus: loadStatus ?? this.loadStatus,
      data: data ?? this.data,
      selectedAddressId: selectedAddressId ?? this.selectedAddressId,
      selectedPaymentId: selectedPaymentId ?? this.selectedPaymentId,
    );
  }
}