import 'package:equatable/equatable.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/cart/presentation/controller/cart/cart_cubit.dart';
import 'package:konoz/features/package_details/data/model/package_details_model.dart';
import 'package:konoz/features/package_details/data/repo/package_details_repo.dart';

part 'package_details_state.dart';

/// Factory، بتتوفر بـ BlocProvider(create:) في الراوت.
class PackageDetailsCubit extends SafeCubit<PackageDetailsState> {
  final PackageDetailsRepo _repo;
  final CartCubit _cart;

  PackageDetailsCubit(this._repo, this._cart)
    : super(const PackageDetailsState());

  String _id = '';

  Future<void> load(String id) async {
    _id = id;
    emit(state.copyWith(status: PackageDetailsStatus.loading));

    final res = await _repo.getPackageDetails(id);
    if (isClosed) return;

    res.fold(
      (f) => emit(
        state.copyWith(status: PackageDetailsStatus.failure, failure: f),
      ),
      (p) => emit(
        state.copyWith(status: PackageDetailsStatus.success, package: p),
      ),
    );
  }

  Future<void> retry() => load(_id);

  /// الـ API مفيهوش إضافة باكدج للسلة، فبنضيف منتجاتها واحد واحد.
  /// لو واحد فشل بنقف (اللي اتضاف قبله بيفضل في السلة).
  Future<void> addToCart() async {
    final pkg = state.package;
    if (pkg == null || pkg.products.isEmpty || state.isAdding) return;

    emit(state.copyWith(addStatus: PackageAddStatus.loading));

    for (final p in pkg.products) {
      final res = await _cart.addToCart(
        productId: p.id,
        size: p.size,
        quantity: p.quantity,
      );
      if (isClosed) return;

      AppFailure? error;
      res?.fold((f) => error = f, (_) {});

      // res == null: الضغطة اتجاهلت (فيه إضافة تانية شغالة)
      if (res == null || error != null) {
        emit(
          state.copyWith(
            addStatus: PackageAddStatus.failure,
            addFailure: error,
          ),
        );
        return;
      }
    }

    emit(state.copyWith(addStatus: PackageAddStatus.success));
  }
}
