import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/supabase_db_service.dart';
import 'package:konoz/features/profile/data/model/profile_model.dart';
import 'package:konoz/features/profile/data/repo/profile_repo.dart';
import 'package:konoz/generated/locale_keys.g.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  @override
  Future<Either<AppFailure, Unit>> updateProfile({
    required String name,
    required String email,
  }) async {
    try {
      await _db.updateDocument(
        path: 'profiles',
        id: _userId,
        data: {'name': name, 'email': email},
      );
      return const Right(unit);
    } catch (e) {
      return Left(RemoteServerFailure.from(e));
    }
  }

  @override
  Future<Either<AppFailure, AddressModel>> addAddress({
    required String title,
    required String fullAddress,
    required double lat,
    required double lng,
    required bool isDefault,
  }) async {
    try {
      final data = {
        'user_id': _userId,
        'title': title,
        'full_address': fullAddress,
        'lat': lat,
        'lng': lng,
        'is_default': isDefault,
      };
      final id = await _db.addDocument(path: 'addresses', data: data);
      return Right(AddressModel.fromJson({...data, 'id': id}));
    } catch (e) {
      return Left(RemoteServerFailure.from(e));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> deleteAddress({required int id}) async {
    try {
      await _db.deleteDocument(path: 'addresses', id: id.toString());
      return const Right(unit);
    } catch (e) {
      return Left(RemoteServerFailure.from(e));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> setDefaultAddress({required int id}) async {
    try {
      await _db.callRpc(
        function: 'set_default_address',
        params: {'p_address_id': id},
      );
      return const Right(unit);
    } catch (e) {
      return Left(RemoteServerFailure.from(e));
    }
  }

  String get _userId {
    final id = _db.currentUser?.id;
    if (id == null) {
      throw const AuthException('Not authenticated', statusCode: '401');
    }
    return id;
  }
}
