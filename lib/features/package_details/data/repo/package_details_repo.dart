import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/package_details/data/model/package_details_model.dart';

abstract class PackageDetailsRepo {
  Future<Either<AppFailure, PackageDetailsModel>> getPackageDetails(String id);
}
