part of 'checkout_cubit.dart';

 

enum CheckoutStatus { initial, loading, success, failure }

class CheckoutState {
  final CheckoutStatus status;
  final AppFailure? failure;
  final PlacedOrderModel? order;

  /// العنوان اللي اليوزر اختاره (null = نستخدم الافتراضي)
  final int? selectedAddressId;

  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.failure,
    this.order,
    this.selectedAddressId,
  });

  bool get isLoading => status == CheckoutStatus.loading;
  bool get isSuccess => status == CheckoutStatus.success;
  bool get isFailure => status == CheckoutStatus.failure;

  // failure بيتصفّر عن قصد لو متبعتش
  CheckoutState copyWith({
    CheckoutStatus? status,
    AppFailure? failure,
    PlacedOrderModel? order,
    int? selectedAddressId,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      failure: failure,
      order: order ?? this.order,
      selectedAddressId: selectedAddressId ?? this.selectedAddressId,
    );
  }
}