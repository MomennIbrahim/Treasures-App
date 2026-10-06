import 'package:equatable/equatable.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/cart/data/repo/cart_repo.dart';

part 'cart_state.dart';

class CartCubit extends SafeCubit<CartState> {
  final CartRepo repo;
  CartCubit(this.repo) : super(const CartState());

  Future<void> loadCount() async {
    final result = await repo.getCartCount();
    result.fold((_) {}, (c) => emit(state.copyWith(count: c)));
  }

  Future<void> addToCart({required int sizeId, int quantity = 1}) async {
    if (state.isAdding) return;

    emit(state.copyWith(actionStatus: CartActionStatus.loading));

    final result = await repo.addToCart(sizeId: sizeId, quantity: quantity);
    result.fold(
      (f) => emit(
        state.copyWith(actionStatus: CartActionStatus.failure, failure: f),
      ),
      (_) => emit(
        state.copyWith(
          actionStatus: CartActionStatus.success,
          count: state.count + quantity,
        ),
      ),
    );
  }

  /// عند الـ logout
  void clear() => emit(const CartState());
}
