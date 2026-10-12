import 'package:equatable/equatable.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/auth/data/repo/auth_repo.dart';

part 'google_sign_in_state.dart';

class GoogleSignInCubit extends SafeCubit<GoogleSignInState> {
  final AuthRepo _repo;
  GoogleSignInCubit(this._repo) : super(const GoogleSignInState());

  Future<void> signIn() async {
    if (state.isLoading) return;
    emit(state.copyWith(status: GoogleStatus.loading));

    final res = await _repo.signInWithGoogle();
    if (isClosed) return;

    res.fold(
      (f) => emit(state.copyWith(status: GoogleStatus.failure, failure: f)),
      // user == null يعني كنسل، فنرجع للحالة الأولى من غير خطأ
      (user) => emit(
        state.copyWith(
          status: user == null ? GoogleStatus.initial : GoogleStatus.success,
        ),
      ),
    );
  }
}