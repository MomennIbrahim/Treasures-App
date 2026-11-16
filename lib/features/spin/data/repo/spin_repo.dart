import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/spin/data/model/spin_wheel_model.dart';

abstract class SpinRepo {
  /// الأقسام + هل العجلة متاحة (enabled)
  Future<Either<AppFailure, SpinWheelModel>> getWheel();

  /// بيلف العجلة على السيرفر وبيرجّع القطاع الفايز
  Future<Either<AppFailure, SpinSection>> spin();
}
