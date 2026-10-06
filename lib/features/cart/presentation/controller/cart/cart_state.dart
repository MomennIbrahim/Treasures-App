part of 'cart_cubit.dart';

enum CartActionStatus { idle, loading, success, failure }

extension CartActionStatusX on CartState {
  bool get isIdle => actionStatus == CartActionStatus.idle;
  bool get isLoading => actionStatus == CartActionStatus.loading;
  bool get isSuccess => actionStatus == CartActionStatus.success;
  bool get isFailure => actionStatus == CartActionStatus.failure;
}

class CartState extends Equatable {
  final CartActionStatus actionStatus;
  final AppFailure? failure;
  final int count;

  const CartState({
    this.actionStatus = CartActionStatus.idle,
    this.failure,
    this.count = 0,
  });

  bool get isAdding => actionStatus == CartActionStatus.loading;

  CartState copyWith({
    CartActionStatus? actionStatus,
    AppFailure? failure,
    int? count,
  }) {
    return CartState(
      actionStatus: actionStatus ?? this.actionStatus,
      failure: failure,
      count: count ?? this.count,
    );
  }

  @override
  List<Object?> get props => [actionStatus, failure, count];
}