import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/collections/data/model/collections_model.dart';

abstract class CollectionsRepo {
  Future<Either<AppFailure, CollectionsModel>> getCollections();
}
