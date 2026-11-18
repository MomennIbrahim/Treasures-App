import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/profile/data/model/profile_model.dart';

abstract class ProfileRepo {
  Future<Either<AppFailure, ProfileModel>> getProfile();

  /// PATCH /auth/me — ابعت الحقول اللي اتغيّرت بس (واحد على الأقل).
  /// email فاضي ('') معناه مسح الإيميل.
  Future<Either<AppFailure, ProfileModel>> updateProfile({
    String? name,
    String? email,
    String? phone,
  });

  /// PATCH /auth/me — [currentPassword] مطلوب لو الحساب له كلمة مرور.
  Future<Either<AppFailure, Unit>> changePassword({
    required String newPassword,
    String? currentPassword,
  });

  /// DELETE /auth/me — [password] مطلوب لو الحساب له كلمة مرور.
  Future<Either<AppFailure, Unit>> deleteAccount({String? password});

  Future<Either<AppFailure, AddressModel>> addAddress({
    required String title,
    required String fullAddress,
    required double lat,
    required double lng,
    required bool isDefault,
  });

  Future<Either<AppFailure, Unit>> deleteAddress({required int id});
  Future<Either<AppFailure, Unit>> setDefaultAddress({required int id});
}