import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/profile/data/model/profile_model.dart';
 
abstract class ProfileRepo {
  Future<Either<AppFailure, ProfileModel>> getProfile();
}
