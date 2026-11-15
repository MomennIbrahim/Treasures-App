import 'package:equatable/equatable.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/di/dependency_injection.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/local_storage/session_storage.dart';
import 'package:konoz/features/auth/data/repo/auth_repo.dart';
import 'package:konoz/features/cart/presentation/controller/cart/cart_cubit.dart';
import 'package:konoz/features/profile/presentation/controllers/profile/profile_cubit.dart';

part 'logout_state.dart';

class LogoutCubit extends SafeCubit<LogoutState> {
  final AuthRepo authRepo;
  LogoutCubit(this.authRepo) : super(LogoutState());

  Future<void> logout() async {
    if (state.status == LogoutStatus.loading) return;
    emit(state.copyWith(status: LogoutStatus.loading));

    final result = await authRepo.signOut();

    // نمسح الجلسة محليًا في الحالتين (نجح أو فشل)،
    // لأن التوكن ممكن يكون منتهي والسيرفر يرجّع 401 وساعتها اليوزر يفضل عالق
    await SessionStorage.clear();
    getIt<ProfileCubit>().clear();
    getIt<CartCubit>().clear();

    result.fold(
      (l) => emit(state.copyWith(status: LogoutStatus.success)),
      (r) => emit(state.copyWith(status: LogoutStatus.success)),
    );
  }
}
