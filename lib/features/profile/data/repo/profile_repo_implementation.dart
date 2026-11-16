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

  // حدود السيرفر: title حتى 80، fullAddress حتى 500
  static const _maxTitle = 80;
  static const _maxAddress = 500;

  Map<String, dynamic> _data(dynamic body) =>
      (body as Map<String, dynamic>)['data'] as Map<String, dynamic>? ?? {};

  List<AddressModel> _addresses(Map<String, dynamic> data) =>
      (data['addresses'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(AddressModel.fromJson)
          .toList();

  String _clip(String s, int max) => s.length > max ? s.substring(0, max) : s;

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

  /// POST /addresses — أول عنوان بيبقى افتراضي تلقائيًا،
  /// و`isDefault: true` بيلغي الافتراضي عن باقي العناوين.
  /// الـ body camelCase زي التوثيق (title, fullAddress, isDefault, lat, lng).
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
        endPoint: EndPoint.addresses,
        data: {
          'title': _clip(title.trim(), _maxTitle),
          'fullAddress': _clip(fullAddress.trim(), _maxAddress),
          'isDefault': isDefault,
          'lat': lat,
          'lng': lng,
        },
      );
      return Right(AddressModel.fromJson(_data(res.data)));
    } catch (e) {
      return Left(toFailure(e));
    }
  }

  /// DELETE /addresses/{id}
  @override
  Future<Either<AppFailure, Unit>> deleteAddress({required int id}) async {
    try {
      await _apiService.deleteData(endPoint: EndPoint.address(id));
      return const Right(unit);
    } catch (e) {
      return Left(toFailure(e));
    }
  }

  /// POST /addresses/{id}/default
  @override
  Future<Either<AppFailure, Unit>> setDefaultAddress({required int id}) async {
    try {
      await _apiService.postData(endPoint: EndPoint.addressDefault(id));
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