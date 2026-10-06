import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/supabase_db_service.dart';
import 'package:konoz/features/auth/data/model/user_model.dart';
import 'package:konoz/features/auth/data/repo/auth_repo.dart';
import 'package:konoz/generated/locale_keys.g.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepoImplmentation implements AuthRepo {
  final SupabaseDbService _dbService;

  AuthRepoImplmentation(this._dbService);

  String _msg(String message) =>
      message.isNotEmpty ? message : LocaleKeys.errors_errors_unexpected.tr();

  @override
  Future<Either<AppFailure, Unit>> sendOtp({required String phone}) async {
    try {
      await _dbService.sendOtp(phone: phone);
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(RemoteServerFailure(_msg(e.message)));
    } catch (e) {
      return Left(RemoteServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, UserModel>> verifyOtp({
    required String phone,
    required String code,
  }) async {
    try {
      final response = await _dbService.verifyOtp(phone: phone, token: code);
      final user = response.user;
      if (user == null) {
        return Left(
          RemoteServerFailure(LocaleKeys.errors_errors_unexpected.tr()),
        );
      }

      return Right(UserModel.fromSupabase(user));
    } on AuthException catch (e) {
      return Left(RemoteServerFailure(_msg(e.message)));
    } catch (e) {
      return Left(RemoteServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> updateName({required String name}) async {
    try {
      await _dbService.updateUserName(name: name);
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(RemoteServerFailure(_msg(e.message)));
    } on PostgrestException catch (e) {
      return Left(RemoteServerFailure(_msg(e.message)));
    } catch (e) {
      return Left(RemoteServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> signOut() async {
    try {
      await _dbService.signOut();
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(RemoteServerFailure(_msg(e.message)));
    } catch (e) {
      return Left(RemoteServerFailure(e.toString()));
    }
  }
}
