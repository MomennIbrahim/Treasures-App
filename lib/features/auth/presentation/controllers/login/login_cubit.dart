import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/di/dependency_injection.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/local_storage/session_storage.dart';
import 'package:konoz/core/notifications/notification_service.dart';
import 'package:konoz/core/validation/egyption_phone_validator.dart';
import 'package:konoz/features/auth/data/model/user_model.dart';
import 'package:konoz/features/auth/data/repo/auth_repo.dart';

part 'login_state.dart';

class LoginCubit extends SafeCubit<LoginState> {
  final AuthRepo _repo;

  LoginCubit(this._repo) : super(const LoginState());

  Future<void> login({
    required String rawPhone,
    required String password,
  }) async {
    if (state.isLoading) return;
    emit(state.copyWith(status: LoginStatus.loading));

    final res = await _repo.login(
      phone: toApiPhone(rawPhone),
      password: password,
    );
    await res.fold<Future<void>>(
      (failure) async =>
          emit(state.copyWith(status: LoginStatus.failure, failure: failure)),
      (auth) async {
        await SessionStorage.save(
          accessToken: auth.token,
          refreshToken: auth.refreshToken,
        );
        unawaited(getIt<NotificationService>().registerToken());
        emit(state.copyWith(status: LoginStatus.success, auth: auth));
      },
    );
  }
}
