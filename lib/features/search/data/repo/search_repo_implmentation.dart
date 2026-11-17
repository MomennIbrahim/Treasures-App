import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/helper/require_login.dart';
 import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/search/data/repo/search_repo.dart';

class SearchRepoImplementation implements SearchRepo {
   SearchRepoImplementation();

  @override
  Future<Either<AppFailure, List<ProductItemModel>>> searchProducts(
    String query,
  ) async {
    try {
      
      return Right( []);
    } catch (e) {
      return Left(RemoteServerFailure.from(e));
    }
  }

  @override
  Future<Either<AppFailure, List<String>>> getTrending() async {
    try {
      // final res = await _db.callRpc(
      //   function: 'get_trending_searches',
      //   params: {'p_limit': 7},
      // );
   //   final list = (res as List?) ?? [];
      return Right([]);
    } catch (e) {
      return Left(RemoteServerFailure.from(e));
    }
  }

  @override
  Future<List<String>> getSuggestions(String query) async {
    try {
      // final res = await _db.callRpc(
      //   function: 'get_search_suggestions',
      //   params: {'p_query': query.trim(), 'p_limit': 6},
      // );
      // return ((res as List?) ?? [])
      //     .map((e) {
      //       if (e is! Map) return e?.toString();
      //       // العمود اسمه suggestion، وfallback لـ term لو اتغيّر تاني
      //       return (e['suggestion'] ?? e['term'])?.toString();
      //     })
      //     .whereType<String>()
      //     .where((s) => s.trim().isNotEmpty)
      //     .toList();
      return [];
    } catch (e) {
      if (kDebugMode) debugPrint('getSuggestions error: $e');
      return []; // الاقتراحات مش لازم تظهر خطأ
    }
  }

  @override
  Future<void> logSearch(String query) async {
    if (!isLoggedIn) return; // الزائر مبيتسجلش بحثه، ومفيش request ملوش لازمة
    try {
   //   await _db.callRpc(function: 'log_search', params: {'p_term': query});
    } catch (_) {
      // التسجيل مش لازم يعطّل البحث
    }
  }
}
