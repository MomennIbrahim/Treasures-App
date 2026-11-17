import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/core/networking/endpoints.dart';
import 'package:konoz/features/home/data/repo/home_repo_implementation.dart'; // toFailure
import 'package:konoz/features/spin/data/model/spin_result_model.dart';
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

  /// POST /spin-wheel/spins  body: { "sectionId": 9 }  (بالتوكن)
  @override
  Future<Either<AppFailure, SpinResultModel>> submitSpin({
    required int sectionId,
  }) async {
    try {
      final res = await _api.postData(
        endPoint: EndPoint.spinWheelSpins,
        data: {'sectionId': sectionId},
      );
      return Right(SpinResultModel.fromApi(_map(res.data)));
    } catch (e) {
      return Left(toFailure(e));
    }
  }
}