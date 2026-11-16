import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/core/networking/endpoints.dart';
import 'package:konoz/features/home/data/repo/home_repo_implementation.dart'; // toFailure
import 'package:konoz/features/spin/data/model/spin_wheel_model.dart';
import 'package:konoz/features/spin/data/repo/spin_repo.dart';

class SpinRepoImplementation implements SpinRepo {
  final ApiService _api;
  SpinRepoImplementation(this._api);

  Map<String, dynamic> _map(dynamic v) =>
      v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};

  @override
  Future<Either<AppFailure, SpinWheelModel>> getWheel() async {
    try {
      final res = await _api.getData(endPoint: EndPoint.spinWheel);
      return Right(SpinWheelModel.fromApi(_map(res.data)));
    } catch (e) {
      return Left(toFailure(e));
    }
  }

  /// ⚠️ افتراض: `POST /spin-wheel` (نفس مسار الـ GET) بالتوكن.
  /// الرد المتوقع: { data: { id, label?, color? } } أو { data: { section: {...} } }
  /// أو { data: { section_id } } — بنتحمل الأشكال دي.
  @override
  Future<Either<AppFailure, SpinSection>> spin() async {
    try {
      final res = await _api.postData(endPoint: EndPoint.spinWheel);
      final data = _map(_map(res.data)['data']);
      final raw = data['section'] is Map ? _map(data['section']) : data;
      final id = raw['id'] ?? raw['section_id'] ?? data['section_id'];
      if (id == null) throw const FormatException('Invalid spin response');
      return Right(SpinSection.fromApi({...raw, 'id': id}));
    } catch (e) {
      return Left(toFailure(e));
    }
  }
}
