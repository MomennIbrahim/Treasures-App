import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/faq/data/model/faq_model.dart';

abstract class FaqRepo {
  /// `GET /faqs`: من غير page / per_page بترجع كل الأسئلة
  Future<Either<AppFailure, List<FaqModel>>> getFaqs();
}
