import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/spin/data/model/spin_result_model.dart';
import 'package:konoz/features/spin/data/model/spin_wheel_model.dart';
import 'package:konoz/features/spin/data/repo/spin_repo.dart';

part 'spin_state.dart';

class SpinCubit extends SafeCubit<SpinState> {
  final SpinRepo _repo;
  SpinCubit(this._repo) : super(const SpinState());

  /// [silent] = true: تحديث هادي (بعد اللف / بعد اللوجين) من غير loader
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

  /// بتتنادى بعد ما العجلة تقف على [sectionId]: بتسجّل اللفّة على اليوزر
  /// وبترجّع النتيجة (null لو فشلت أو فيه طلب شغال).
  Future<SpinResultModel?> submitSpin(int sectionId) async {
    if (state.isSpinRequesting) return null;
    emit(state.copyWith(spinStatus: SpinRequestStatus.loading));

    final result = await _repo.submitSpin(sectionId: sectionId);
    return result.fold<SpinResultModel?>(
      (f) {
        emit(
          state.copyWith(
            spinStatus: SpinRequestStatus.failure,
            spinFailure: f,
          ),
        );
        return null;
      },
      (r) {
        emit(
          state.copyWith(
            spinStatus: SpinRequestStatus.success,
            result: r,
            // اللفّة اتستهلكت: الكارد في الهوم يختفي
            wheel: state.wheel?.copyWith(hasSpin: false),
          ),
        );
        return r;
      },
    );
  }
}