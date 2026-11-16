import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/spin/data/model/spin_wheel_model.dart';
import 'package:konoz/features/spin/data/repo/spin_repo.dart';

part 'spin_state.dart';

class SpinCubit extends SafeCubit<SpinState> {
  final SpinRepo _repo;
  SpinCubit(this._repo) : super(const SpinState());

  /// [silent] = true: تحديث هادي (بعد اللف) من غير loader
  Future<void> getWheel({bool silent = false}) async {
    if (state.status == SpinLoadStatus.loading) return;
    if (!silent || state.wheel == null) {
      emit(state.copyWith(status: SpinLoadStatus.loading));
    }

    final result = await _repo.getWheel();
    result.fold(
      (f) => emit(
        state.copyWith(
          // تحديث هادي فشل: نسيب العجلة الحالية زي ما هي
          status: state.wheel != null
              ? SpinLoadStatus.success
              : SpinLoadStatus.failure,
          failure: state.wheel != null ? null : f,
        ),
      ),
      (wheel) =>
          emit(state.copyWith(status: SpinLoadStatus.success, wheel: wheel)),
    );
  }

  /// بيلف على السيرفر وبيرجّع القطاع الفايز (null لو فشل أو فيه طلب شغال).
  /// الشاشة هي اللي بتلف الأنيميشن على القطاع ده.
  Future<SpinSection?> spin() async {
    if (state.isSpinRequesting) return null;
    emit(state.copyWith(spinStatus: SpinRequestStatus.loading));

    final result = await _repo.spin();
    return result.fold<SpinSection?>(
      (f) {
        emit(
          state.copyWith(
            spinStatus: SpinRequestStatus.failure,
            spinFailure: f,
          ),
        );
        return null;
      },
      (section) {
        emit(
          state.copyWith(
            spinStatus: SpinRequestStatus.success,
            result: section,
          ),
        );
        return section;
      },
    );
  }
}