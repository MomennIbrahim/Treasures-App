import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/cart/presentation/controller/cart/cart_cubit.dart';
import 'package:konoz/features/checkout/data/model/checkout_model.dart';
import 'package:konoz/features/checkout/data/repo/checkout_repo.dart';

part 'checkout_state.dart';

class CheckoutCubit extends SafeCubit<CheckoutState> {
  final CheckoutRepo _repo;
  final CartCubit _cart;

  CheckoutCubit(this._repo, this._cart) : super(const CheckoutState());

  void selectAddress(int id) => emit(state.copyWith(selectedAddressId: id));
  void selectPayment(String id) => emit(state.copyWith(selectedPaymentId: id));

  /// طرق الدفع والمجاميع. لو فشلت الشاشة تشتغل بـ cod والسلة.
  Future<void> load() async {
    if (state.isDataLoading) return;
    emit(state.copyWith(loadStatus: CheckoutStatus.loading));
    final res = await _repo.getCheckout();
    if (isClosed) return;
    res.fold(
      (f) => emit(state.copyWith(loadStatus: CheckoutStatus.failure)),
      (data) => emit(
        state.copyWith(loadStatus: CheckoutStatus.success, data: data),
      ),
    );
  }

  Future<void> placeOrder({required int addressId}) async {
    if (state.isLoading) return; // منع الضغط المزدوج

    emit(state.copyWith(status: CheckoutStatus.loading));
    final result = await _repo.placeOrder(
      addressId: addressId,
      paymentMethod: state.paymentMethod,
    );
    if (isClosed) return;

    result.fold(
      (f) => emit(state.copyWith(status: CheckoutStatus.failure, failure: f)),
      (order) =>
          emit(state.copyWith(status: CheckoutStatus.success, order: order)),
    );

    // نجاح: السلة اتفرّغت. فشل (out_of_stock): نعرض المخزون الحقيقي.
    await _cart.getCart();
  }
}
