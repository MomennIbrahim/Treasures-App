import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/core/networking/endpoints.dart';
import 'package:konoz/features/home/data/repo/home_repo_implementation.dart'; // toFailure
import 'package:konoz/features/profile/data/model/profile_model.dart';
import 'package:konoz/features/profile/data/repo/profile_repo.dart';

class ProfileRepoImplementation implements ProfileRepo {
  final ApiService _apiService;
  ProfileRepoImplementation(this._apiService);


  Map<String, dynamic> _data(dynamic body) =>
      (body as Map<String, dynamic>)['data'] as Map<String, dynamic>? ?? {};

  List<AddressModel> _addresses(Map<String, dynamic> data) =>
      (data['addresses'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(AddressModel.fromJson)
          .toList();



  @override
  Future<Either<AppFailure, ProfileModel>> getProfile() async {
    try {
      final res = await _apiService.getData(endPoint: EndPoint.me);
      final data = _data(res.data);
      return Right(ProfileModel.fromJson(data, addresses: _addresses(data)));
    } catch (e) {
      return Left(toFailure(e));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> updateProfile({required String name}) async {
    try {
      await _apiService.putData(endPoint: EndPoint.me, data: {'name': name});
      return const Right(unit);
    } catch (e) {
      return Left(toFailure(e));
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
      final res = await _apiService.postData(
        endPoint: EndPoint.banners,
        data: {
          'title': title,
          'full_address': fullAddress,
          'lat': lat,
          'lng': lng,
          'is_default': isDefault,
        },
      );
      return Right(AddressModel.fromJson(_data(res.data)));
    } catch (e) {
      return Left(toFailure(e));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> deleteAddress({required int id}) async {
    try {
      await _apiService.deleteData(endPoint: EndPoint.banners);
      return const Right(unit);
    } catch (e) {
      return Left(toFailure(e));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> setDefaultAddress({required int id}) async {
    try {
      await _apiService.patchData(endPoint: EndPoint.collections);
      return const Right(unit);
    } catch (e) {
      return Left(toFailure(e));
    }
  }

  /// الـ API بيعتمد الرقم كهوية دخول، فمفيش تعديل له (متأكد من الـ PDF؟).
  @override
  Future<Either<AppFailure, Unit>> updatePhone({required String phone}) async =>
      Left(RemoteServerFailure('Phone update is not supported'));
}
