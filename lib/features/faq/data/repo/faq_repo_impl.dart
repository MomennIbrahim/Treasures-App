import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/faq/data/model/faq_model.dart';
import 'package:konoz/features/faq/data/repo/faq_repo.dart';
import 'package:konoz/features/home/data/repo/home_repo_implementation.dart';

class FaqRepoImpl implements FaqRepo {
  // افتراض 1: الـ client عندك Dio، والـ baseUrl فيه /api/v1
  // لو عندك wrapper (ApiService / DioClient) بدّل النوع واستدعاء get تحت.
  final Dio _dio;
  FaqRepoImpl(this._dio);

  @override
  Future<Either<AppFailure, List<FaqModel>>> getFaqs() async {
    try {
      final res = await _dio.get('/faqs');
      return Right(FaqModel.listFromApi(res.data));
    } catch (e) {
      return Left(toFailure(e));
    }
  }
}
