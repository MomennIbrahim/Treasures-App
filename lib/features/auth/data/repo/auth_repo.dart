import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/auth/data/model/user_model.dart';

abstract class AuthRepo {
  Future<Either<AppFailure, AuthResponseModel>> register({
    required String phone,
    required String name,
    required String password,
  });

  Future<Either<AppFailure, AuthResponseModel>> login({
    required String phone,
    required String password,
  });

  Future<Either<AppFailure, Unit>> updateName({required String name});

  Future<Either<AppFailure, Unit>> signOut();
}
