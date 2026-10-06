import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/auth/data/model/user_model.dart';

abstract class AuthRepo {
  /// الخطوة 1: يبعت كود SMS
  Future<Either<AppFailure, Unit>> sendOtp({required String phone});

  /// الخطوة 2: يتحقق من الكود ويسجل الدخول
  Future<Either<AppFailure, UserModel>> verifyOtp({
    required String phone,
    required String code,
  });

  Future<Either<AppFailure, Unit>> updateName({required String name});

  Future<Either<AppFailure, Unit>> signOut();
}