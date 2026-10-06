import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/profile/data/model/profile_model.dart';

abstract class ProfileRepo {
  Future<Either<AppFailure, ProfileModel>> getProfile();

  Future<Either<AppFailure, Unit>> updateProfile({
    required String name,
    required String email,
  });

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
