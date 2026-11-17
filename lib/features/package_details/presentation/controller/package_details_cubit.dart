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

 
 Future<void> addToCart() async {
    if (state.package == null || state.isAdding) return;

    emit(state.copyWith(addStatus: PackageAddStatus.loading));

    final res = await _cart.addPackage(packageId: _id);
    if (isClosed) return;

    // res == null: الضغطة اتجاهلت (فيه إضافة تانية شغالة)
    if (res == null) {
      emit(state.copyWith(addStatus: PackageAddStatus.idle));
      return;
    }

    AppFailure? error;
    res.fold((f) => error = f, (_) {});

    emit(
      state.copyWith(
        addStatus: error == null
            ? PackageAddStatus.success
            : PackageAddStatus.failure,
        addFailure: error,
      ),
    );
  }
}
