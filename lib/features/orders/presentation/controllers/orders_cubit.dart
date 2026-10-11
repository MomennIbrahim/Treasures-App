import 'package:equatable/equatable.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/orders/data/model/order_model.dart';
import 'package:konoz/features/orders/data/model/orders_filter.dart';
import 'package:konoz/features/orders/data/repo/orders_repo.dart';

part 'orders_state.dart';

class OrdersCubit extends SafeCubit<OrdersState> {
  final OrdersRepo _repo;
  OrdersCubit(this._repo) : super(const OrdersState());

  int _requestId = 0; // يتجاهل الردود القديمة لو غيّر الفلتر بسرعة

  /// silent = refresh هادي من غير skeleton (سحب للتحديث)
  Future<void> getOrders({OrdersFilter? filter, bool silent = false}) async {
    final f = filter ?? state.filter;
    final changed = f != state.filter;
    final id = ++_requestId;

    final keepVisible = silent && !changed && state.orders.isNotEmpty;
    emit(
      state.copyWith(
        filter: f,
        status: keepVisible ? OrdersStatus.success : OrdersStatus.loading,
        orders: changed ? const [] : null,
      ),
    );

    final res = await _repo.getOrders(filter: f);
    if (id != _requestId || isClosed) return;

    res.fold(
      (failure) => emit(
        state.copyWith(status: OrdersStatus.failure, failure: failure),
      ),
      (orders) => emit(
        state.copyWith(status: OrdersStatus.success, orders: orders),
      ),
    );
  }

  void setFilter(OrdersFilter filter) {
    if (filter == state.filter && state.status == OrdersStatus.success) return;
    getOrders(filter: filter);
  }

  void onSearchChanged(String value) => emit(state.copyWith(query: value));

  Future<void> retry() => getOrders();
}