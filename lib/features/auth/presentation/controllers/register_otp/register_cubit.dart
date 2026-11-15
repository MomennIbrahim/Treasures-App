import 'package:equatable/equatable.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/helper/format_egyption_number.dart';
import 'package:konoz/core/local_storage/session_storage.dart';
import 'package:konoz/features/auth/data/model/user_model.dart';
import 'package:konoz/features/auth/data/repo/auth_repo.dart';

part 'register_state.dart';

class RegisterCubit extends SafeCubit<RegisterState> {
  final AuthRepo authRepo;

  RegisterCubit(this.authRepo) : super(const RegisterState());

  Future<void> register({
    required String name,
    required String rawPhone,
    required String password,
  }) async {
    final phone = formatEgyptPhone(rawPhone);

    emit(state.copyWith(status: RegisterStatus.loading));

    final result = await authRepo.register(
      name: name,
      phone: phone,
      password: password,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: RegisterStatus.failure, failure: failure),
      ),
      (auth) async {
        await SessionStorage.save(auth);
        emit(state.copyWith(status: RegisterStatus.success, auth: auth));
      },
    );
  }
}
