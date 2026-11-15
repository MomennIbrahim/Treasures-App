import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/core/networking/endpoints.dart';
import 'package:konoz/core/networking/supabase_db_service.dart';
import 'package:konoz/features/home/data/repo/home_repo_implementation.dart';
import 'package:konoz/features/profile/data/model/profile_model.dart';
import 'package:konoz/features/profile/data/repo/profile_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepoImplementation implements ProfileRepo {
  final ApiService _apiService;
  final SupabaseDbService _db;
  ProfileRepoImplementation(this._apiService, this._db);

  @override
  Future<Either<AppFailure, ProfileModel>> getProfile() async {
    try {
      final res = await _apiService.getData(
        endPoint: EndPoint.me,
      ); // '/auth/me'
      final body = res.data as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>? ?? {};

      final addresses = (data['addresses'] as List? ?? [])
          .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return Right(ProfileModel.fromJson(data, addresses: addresses));
    } catch (e) {
      return Left(toFailure(e));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> updateProfile({required String name}) async {
    try {
      await _db.updateDocument(
        path: 'profiles',
        id: _userId,
        data: {'name': name},
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

  @override
  Future<Either<AppFailure, Unit>> updatePhone({required String phone}) async {
    try {
      final id = _db.currentUser!.id;
      await _db.updateDocument(
        path: 'profiles',
        id: id,
        data: {'phone': phone},
      );
      return const Right(unit);
    } catch (e) {
      return Left(RemoteServerFailure.from(e));
    }
  }
}
