import 'package:dartz/dartz.dart' show Either, Left, Right, Unit, unit;
import 'package:konoz/core/constance/app_keys.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/cart/data/model/cart_item_model.dart';
import 'package:konoz/features/cart/data/model/cart_model.dart';
import 'package:konoz/features/cart/data/model/cart_summary_model.dart';
import 'package:konoz/features/cart/data/repo/cart_repo.dart';

part 'cart_state.dart';

class CartCubit extends SafeCubit<CartState> {
  final CartRepo _repo;
  CartCubit(this._repo) : super(const CartState());

  /// عداد للعمليات (+/-/حذف). آخر عملية بس هي اللي رد السيرفر بتاعها بيتطبق،
  /// فلو اليوزر ضغط بسرعة مفيش رد قديم يرجّع الكمية لورا.
  int _mutation = 0;

  bool get _loggedIn => AppConstance.userToken != null;

  // ───────── badge ─────────
  Future<void> loadCount() async {
    if (!_loggedIn) return;
    final result = await _repo.getCart();
    result.fold((_) {}, (cart) => emit(state.copyWith(count: cart.itemCount)));
  }

  // ───────── تحميل السلة ─────────
  Future<void> getCart() async {
    // مفيش skeleton لو عندنا داتا بالفعل (refresh هادي)
    if (state.items.isEmpty) {
      emit(state.copyWith(status: CartStatus.loading));
    }
    final result = await _repo.getCart();

    result.fold(
      (f) => emit(state.copyWith(status: CartStatus.failure, failure: f)),
      (cart) => emit(_withCart(cart, status: CartStatus.success)),
    );
  }

  /// alias لو في أماكن (زي CheckoutCubit) لسه بتنادي loadCart
  Future<void> loadCart() => getCart();

  // ───────── إضافة ─────────
  // null = الضغطة اتجاهلت لأن فيه إضافة شغالة
  Future<Either<AppFailure, Unit>?> addToCart({
    required String productId,
    required String size,
    int quantity = 1,
  }) async {
    if (state.isAdding) return null;
    emit(
      state.copyWith(
        actionStatus: CartActionStatus.loading,
        action: CartAction.add,
      ),
    );

    final result = await _repo.addToCart(
      productId: productId,
      size: size,
      quantity: quantity,
    );

    return result.fold<Either<AppFailure, Unit>>(
      (f) {
        emit(
          state.copyWith(
            actionStatus: CartActionStatus.failure,
            action: CartAction.add,
            actionFailure: f,
          ),
        );
        return Left(f);
      },
      (cart) {
        _mutation++;
        // emit واحد بس عشان الـ toast ميظهرش مرتين
        emit(
          _withCart(
            cart,
            status: CartStatus.success,
            actionStatus: CartActionStatus.success,
            action: CartAction.add,
          ),
        );
        return const Right(unit);
      },
    );
  }

  // ───────── تعديل الكمية (optimistic) ─────────
  Future<void> updateQuantity(CartItemModel item, int newQty) async {
    if (newQty < 1) return removeItem(item);
    if (newQty > item.inStock) return; // الزرار المفروض معطّل أصلًا

    final seq = ++_mutation;
    final old = state.items;
    final updated = [
      for (final i in old) i.id == item.id ? i.copyWith(quantity: newQty) : i,
    ];
    emit(
      state.copyWith(
        items: updated,
        count: _count(updated),
        actionStatus: CartActionStatus.loading,
        action: CartAction.update,
      ),
    );

    final result = await _repo.updateQuantity(
      itemId: item.id,
      quantity: newQty,
    );
    _applyMutationResult(result, seq, old, CartAction.update);
  }

  // ───────── حذف (optimistic) ─────────
  Future<void> removeItem(CartItemModel item) async {
    final seq = ++_mutation;
    final old = state.items;
    final updated = old.where((i) => i.id != item.id).toList();
    emit(
      state.copyWith(
        items: updated,
        count: _count(updated),
        actionStatus: CartActionStatus.loading,
        action: CartAction.remove,
      ),
    );

    final result = await _repo.removeItem(item.id);
    _applyMutationResult(result, seq, old, CartAction.remove);
  }

  // ───────── مشترك بين التعديل والحذف ─────────
  void _applyMutationResult(
    Either<AppFailure, CartModel> result,
    int seq,
    List<CartItemModel> old,
    CartAction action,
  ) {
    final isLatest = seq == _mutation;
    result.fold(
      (f) {
        emit(
          state.copyWith(
            // نرجّع القديم بس لو مفيش عملية أحدث بعدها
            items: isLatest ? old : null,
            count: isLatest ? _count(old) : null,
            actionStatus: CartActionStatus.failure,
            action: action,
            actionFailure: f,
          ),
        );
      },
      (cart) {
        if (isLatest) {
          emit(
            _withCart(
              cart,
              actionStatus: CartActionStatus.success,
              action: action,
            ),
          );
        } else {
          // فيه عملية أحدث لسه شغالة؛ رَدّها هو اللي هيحدّث الأرقام
          emit(
            state.copyWith(
              actionStatus: CartActionStatus.success,
              action: action,
            ),
          );
        }
      },
    );
  }

  /// بيطبّق رد السيرفر (items + count + summary) في emit واحد
  CartState _withCart(
    CartModel cart, {
    CartStatus? status,
    CartActionStatus? actionStatus,
    CartAction? action,
  }) {
    return state.copyWith(
      status: status,
      items: cart.items,
      count: cart.itemCount,
      summary: cart.summary,
      actionStatus: actionStatus,
      action: action,
    );
  }

  /// عند الـ logout
  void clear() {
    _mutation++;
    emit(const CartState());
  }

  /// عدد الأصناف مش مجموع الكميات
  int _count(List<CartItemModel> items) => items.length;
}