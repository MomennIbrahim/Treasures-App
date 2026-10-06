import 'package:equatable/equatable.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/auth/data/repo/auth_repo.dart';

part 'logout_state.dart';

class LogoutCubit extends SafeCubit<LogoutState> {
  final AuthRepo authRepo;
  LogoutCubit(this.authRepo) : super(LogoutState());

  Future<void> logout() async {
    emit(state.copyWith(status: LogoutStatus.loading));
    final result = await authRepo.signOut();
    result.fold(
      (l) => emit(state.copyWith(status: LogoutStatus.failure, failure: l)),
      (r) => emit(state.copyWith(status: LogoutStatus.success)),
    );
  }
}
