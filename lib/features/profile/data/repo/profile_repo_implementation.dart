import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/supabase_db_service.dart';
import 'package:konoz/features/profile/data/model/profile_model.dart';
import 'package:konoz/features/profile/data/repo/profile_repo.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class ProfileRepoImplementation implements ProfileRepo {
  final SupabaseDbService _db;
  ProfileRepoImplementation(this._db);

  @override
  Future<Either<AppFailure, ProfileModel>> getProfile() async {
    try {
      final userId = _db.currentUser?.id;
      if (userId == null) {
        return Left(
          RemoteServerFailure(LocaleKeys.errors_unauthorized.tr(), 401),
        );
      }

      final profiles = await _db.getCollection(
        path: 'profiles',
        filters: [QueryFilter(field: 'id', isEqualTo: userId)],
        limit: 1,
      );

      final addressesJson = await _db.getCollection(
        path: 'addresses',
        filters: [QueryFilter(field: 'user_id', isEqualTo: userId)],
        orderByField: 'is_default',
        descending: true,
      );

      final addresses = addressesJson.map(AddressModel.fromJson).toList();

      // لو الصف لسه مش موجود، استخدم بيانات الأوث
      final json = profiles.isNotEmpty
          ? profiles.first
          : {'id': userId, 'phone': _db.currentUser?.phone, 'name': ''};

      return Right(ProfileModel.fromJson(json, addresses: addresses));
    } catch (e) {
      return Left(RemoteServerFailure.from(e));
    }
  }
}
