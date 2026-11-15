import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/core/networking/endpoints.dart';
import 'package:konoz/features/auth/data/model/user_model.dart';
import 'package:konoz/features/auth/data/repo/auth_repo.dart';
import 'package:konoz/features/home/data/repo/home_repo_implementation.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class AuthRepoImplmentation implements AuthRepo {
  final ApiService _apiService;

  AuthRepoImplmentation(this._apiService);

  String _msg(String message) =>
      message.isNotEmpty ? message : LocaleKeys.errors_errors_unexpected.tr();

  @override
  Future<Either<AppFailure, AuthResponseModel>> register({
    required String phone,
    required String name,
    required String password,
  }) async {
    try {
      final response = await _apiService.postData(
        endPoint: EndPoint.register,
        data: {'phone': phone, 'name': name, 'password': password},
      );

      final data = response.data as Map<String, dynamic>;

      if (data['succeeded'] != true) {
        return Left(
          RemoteServerFailure(_msg(data['message']?.toString() ?? '')),
        );
      }

      return Right(AuthResponseModel.fromJson(data));
    } catch (e) {
      return Left(toFailure(e));
    }
  }

  @override
  Future<Either<AppFailure, AuthResponseModel>> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _apiService.postData(
        endPoint: EndPoint.login,
        data: {'phone': phone, 'password': password},
      );

      final data = response.data as Map<String, dynamic>;

      if (data['succeeded'] != true) {
        return Left(
          RemoteServerFailure(_msg(data['message']?.toString() ?? '')),
        );
      }

      return Right(AuthResponseModel.fromJson(data));
    } catch (e) {
      return Left(toFailure(e));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> updateName({required String name}) async {
    try {
      await _apiService.putData(endPoint: "", data: {'name': name});

      return const Right(unit);
    } catch (e) {
      return Left(toFailure(e));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> signOut() async {
    try {
      await _apiService.postData(endPoint: EndPoint.logout);

      return const Right(unit);
    } catch (e) {
      return Left(toFailure(e));
    }
  }
}
