import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/cart/data/model/cart_item_model.dart';
import 'package:konoz/features/cart/data/model/cart_summary_model.dart';
import 'package:konoz/features/cart/data/repo/cart_repo.dart';

part 'cart_state.dart';

class CartCubit extends SafeCubit<CartState> {
  final CartRepo _repo;
  CartCubit(this._repo) : super(const CartState());

  /// بيتجاهل ردود الملخص القديمة لو اليوزر ضغط +/- بسرعة
  int _summaryRequest = 0;

  // ───────── badge ─────────
  Future<void> loadCount() async {
    final result = await _repo.getCartCount();
    result.fold((_) {}, (count) => emit(state.copyWith(count: count)));
  }

  // ───────── تحميل السلة ─────────
  Future<void> getCart() async {
    // مفيش skeleton لو عندنا داتا بالفعل (refresh هادي)
    if (state.items.isEmpty) {
      emit(state.copyWith(status: CartStatus.loading));
    }
    final result = await _repo.getCart();

    final ok = result.fold<bool>(
      (f) {
        emit(state.copyWith(status: CartStatus.failure, failure: f));
        return false;
      },
      (items) {
        emit(
          state.copyWith(
            status: CartStatus.success,
            items: items,
            count: _count(items),
          ),
        );
        return true;
      },
    );
    if (ok) await _refreshSummary();
  }

  // ───────── إضافة ─────────
  Future<void> addToCart({required int sizeId, int quantity = 1}) async {
    if (state.isAdding) return;
    emit(
      state.copyWith(
        actionStatus: CartActionStatus.loading,
        action: CartAction.add,
      ),
    );

    final result = await _repo.addToCart(sizeId: sizeId, quantity: quantity);
    final failure = result.fold((f) => f, (_) => null);

    if (failure != null) {
      emit(
        state.copyWith(
          actionStatus: CartActionStatus.failure,
          action: CartAction.add,
          actionFailure: failure,
        ),
      );
      return;
    }

    // السلة الحقيقية من السيرفر (الـ items والعدد في request واحد)
    final cart = await _repo.getCart();

    // emit واحد بس عشان الـ toast ميظهرش مرتين
    cart.fold(
      (_) => emit(
        state.copyWith(
          status: CartStatus.initial,
          actionStatus: CartActionStatus.success,
          action: CartAction.add,
        ),
      ),
      (items) => emit(
        state.copyWith(
          status: CartStatus.success,
          items: items,
          count: _count(items),
          actionStatus: CartActionStatus.success,
          action: CartAction.add,
        ),
      ),
    );
    _refreshSummary();
  }

  // ───────── تعديل الكمية (optimistic) ─────────
  Future<void> updateQuantity(CartItemModel item, int newQty) async {
    if (newQty < 1) return removeItem(item);
    if (newQty > item.inStock) return; // الزرار المفروض معطّل أصلًا

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
    result.fold(
      // رجّع القيمة القديمة
      (f) => emit(
        state.copyWith(
          items: old,
          count: _count(old),
          actionStatus: CartActionStatus.failure,
          action: CartAction.update,
          actionFailure: f,
        ),
      ),
      (_) {
        emit(
          state.copyWith(
            actionStatus: CartActionStatus.success,
            action: CartAction.update,
          ),
        );
        _refreshSummary();
      },
    );
  }

  // ───────── حذف (optimistic) ─────────
  Future<void> removeItem(CartItemModel item) async {
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
    result.fold(
      (f) => emit(
        state.copyWith(
          items: old,
          count: _count(old),
          actionStatus: CartActionStatus.failure,
          action: CartAction.remove,
          actionFailure: f,
        ),
      ),
      (_) {
        emit(
          state.copyWith(
            actionStatus: CartActionStatus.success,
            action: CartAction.remove,
          ),
        );
        _refreshSummary();
      },
    );
  }

  // ───────── ملخص الطلب (من السيرفر) ─────────
  Future<void> _refreshSummary() async {
    final request = ++_summaryRequest;
    final result = await _repo.getSummary();
    if (request != _summaryRequest) return; // رد قديم
    // لو فشل نسيب آخر ملخص، والـ UI عنده fallback
    result.fold((_) {}, (summary) => emit(state.copyWith(summary: summary)));
  }

  /// عند الـ logout
  void clear() {
    _summaryRequest++;
    emit(const CartState());
  }

  /// عدد الأصناف مش مجموع الكميات
  int _count(List<CartItemModel> items) => items.length;
}
