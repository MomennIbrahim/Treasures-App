import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/spin/data/model/spin_result_model.dart';
import 'package:konoz/features/spin/data/model/spin_wheel_model.dart';

abstract class SpinRepo {
  /// الأقسام + هل العجلة متاحة (enabled)
  Future<Either<AppFailure, SpinWheelModel>> getWheel();

  /// بيسجّل اللفّة على اليوزر بعد ما العجلة تقف على [sectionId]
  Future<Either<AppFailure, SpinResultModel>> submitSpin({
    required int sectionId,
  });
}