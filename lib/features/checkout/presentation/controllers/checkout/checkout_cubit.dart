import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/cart/presentation/controller/cart/cart_cubit.dart';
import 'package:konoz/features/checkout/data/model/checkout_model.dart';
import 'package:konoz/features/checkout/data/repo/checkout_rpo.dart';

part 'checkout_state.dart';

/// Factory (instance جديدة لكل شاشة checkout) وبتتوفر بـ BlocProvider(create:) في الراوت.
class CheckoutCubit extends SafeCubit<CheckoutState> {
  final CheckoutRepo _repo;
  final CartCubit _cart;

  CheckoutCubit(this._repo, this._cart) : super(const CheckoutState());

  void selectAddress(int id) => emit(state.copyWith(selectedAddressId: id));

  Future<void> placeOrder({required int addressId}) async {
    if (state.isLoading) return; // منع الضغط المزدوج

    emit(state.copyWith(status: CheckoutStatus.loading));
    final result = await _repo.placeOrder(addressId: addressId);

    result.fold(
      (f) => emit(state.copyWith(status: CheckoutStatus.failure, failure: f)),
      (order) =>
          emit(state.copyWith(status: CheckoutStatus.success, order: order)),
    );

    // في الحالتين نحدّث السلة:
    //  - نجاح: السيرفر فرّغها
    //  - فشل (مثلًا out_of_stock): نعرض المخزون الحقيقي
    await _cart.getCart();
  }
}
