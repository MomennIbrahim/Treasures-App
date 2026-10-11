import 'package:dartz/dartz.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/networking/supabase_db_service.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/search/data/repo/search_repo.dart';

class SearchRepoImplementation implements SearchRepo {
  final SupabaseDbService _db;
  SearchRepoImplementation(this._db);

  @override
  Future<Either<AppFailure, List<ProductItemModel>>> searchProducts(
    String query,
  ) async {
    try {
      final rows = await _db.searchCollection(
        path: 'products',
        field: 'name',
        query: query.trim(),
        columns: '*, product_sizes(*)',
      );
      return Right(rows.map(ProductItemModel.fromSupabase).toList());
    } catch (e) {
      return Left(RemoteServerFailure.from(e));
    }
  }

  @override
  Future<Either<AppFailure, List<String>>> getTrending() async {
    try {
      final res = await _db.callRpc(
        function: 'get_trending_searches',
        params: {'p_limit': 7},
      );
      final list = (res as List?) ?? [];
      return Right(list.map((e) => (e as Map)['term'].toString()).toList());
    } catch (e) {
      return Left(RemoteServerFailure.from(e));
    }
  }

  @override
  Future<List<String>> getSuggestions(String query) async {
    try {
      final res = await _db.callRpc(
        function: 'get_search_suggestions',
        params: {'p_query': query.trim(), 'p_limit': 6},
      );
      return ((res as List?) ?? [])
          .map((e) => (e as Map)['term'].toString())
          .toList();
    } catch (_) {
      return []; // الاقتراحات مش لازم تظهر خطأ
    }
  }

  @override
  Future<void> logSearch(String query) async {
    try {
      await _db.callRpc(function: 'log_search', params: {'p_term': query});
    } catch (_) {
      // التسجيل مش لازم يعطّل البحث
    }
  }
}