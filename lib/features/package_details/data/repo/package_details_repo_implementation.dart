import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/core/networking/endpoints.dart';
// نفس الـ import اللي باقي الـ repos
import 'package:konoz/features/home/data/repo/home_repo_implementation.dart'
    show toFailure;
import 'package:konoz/features/package_details/data/model/package_details_model.dart';
import 'package:konoz/features/package_details/data/repo/package_details_repo.dart';

class PackageDetailsRepoImplementation implements PackageDetailsRepo {
  final ApiService _api;
  PackageDetailsRepoImplementation(this._api);

  @override
  Future<Either<AppFailure, PackageDetailsModel>> getPackageDetails(
    String id,
  ) async {
    try {
      // لو اسم الدالة عندك مختلف عدّله (المسار: /packages/{id})
      final res = await _api.getData(endPoint: EndPoint.packageDetails(id));
      return Right(PackageDetailsModel.fromBody(res.data));
    } catch (e) {
      return Left(toFailure(e));
    }
  }
}
