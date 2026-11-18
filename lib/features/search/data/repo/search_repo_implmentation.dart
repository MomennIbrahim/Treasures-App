import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/helper/require_login.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/core/networking/endpoints.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/home/data/repo/home_repo_implementation.dart'; // toFailure
import 'package:konoz/features/search/data/repo/search_repo.dart';

class SearchRepoImplementation implements SearchRepo {
  final ApiService _apiService;
  SearchRepoImplementation(this._apiService);

  // حدود السيرفر: q حتى 120 حرف، والاقتراحات من حرفين.
  static const _maxQuery = 120;
  static const _minSuggestionChars = 2;
  static const _maxSuggestions = 8;
  static const _trendingLimit = 7;

  String _clip(String s, int max) => s.length > max ? s.substring(0, max) : s;

  /// بنبني الـ query string بنفسنا (مشفّر صح للعربي) بدل ما نعتمد على
  /// شكل queryParameters في ApiService.
  String _url(String path, Map<String, String> query) =>
      Uri(path: path, queryParameters: query).toString();

  List<dynamic> _list(dynamic body) =>
      (body is Map<String, dynamic> ? body['data'] as List? : null) ??
      const [];

  /// GET /products/search?q=
  /// من غير page/per_page السيرفر بيرجّع كل النتايج.
  @override
  Future<Either<AppFailure, List<ProductItemModel>>> searchProducts(
    String query,
  ) async {
    try {
      final q = _clip(query.trim(), _maxQuery);
      final res = await _apiService.getData(
        endPoint: _url(EndPoint.productsSearch, {'q': q}),
      );
      final products = _list(res.data)
          .whereType<Map<String, dynamic>>()
          .map(ProductItemModel.fromJson)
          .toList();
      return Right(products);
    } catch (e) {
      return Left(toFailure(e));
    }
  }

  /// GET /search/trending?limit=7 — مش موجودة في الدليل (مطلوبة من الباك إند).
  /// مش حرجة: أي فشل بيرجّع قائمة فاضية والـ Trending بيختفي.
  @override
  Future<Either<AppFailure, List<String>>> getTrending() async {
    try {
      final res = await _apiService.getData(
        endPoint: _url(EndPoint.searchTrending, {'limit': '$_trendingLimit'}),
      );
      final terms = _list(res.data)
          .map((e) => e is String ? e : (e is Map ? e['term']?.toString() : null))
          .whereType<String>()
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      return Right(terms);
    } catch (e) {
      if (kDebugMode) debugPrint('getTrending error: $e');
      return const Right([]);
    }
  }

  /// GET /products/suggestions?q= — أقل من حرفين السيرفر بيرجّع فاضي،
  /// فبنوفّر الطلب. الرد فيه collections ثم products، وبنعرض الاسم بس.
  @override
  Future<List<String>> getSuggestions(String query) async {
    final q = query.trim();
    if (q.length < _minSuggestionChars) return [];
    try {
      final res = await _apiService.getData(
        endPoint: _url(EndPoint.productsSuggestions, {
          'q': _clip(q, _maxQuery),
        }),
      );
      final names = <String>[];
      for (final e in _list(res.data)) {
        if (e is! Map) continue;
        final name = e['name']?.toString().trim();
        if (name != null && name.isNotEmpty && !names.contains(name)) {
          names.add(name);
        }
      }
      return names.take(_maxSuggestions).toList();
    } catch (e) {
      if (kDebugMode) debugPrint('getSuggestions error: $e');
      return []; // الاقتراحات مش لازم تظهر خطأ
    }
  }

  /// POST /search/log — مش موجودة في الدليل (مطلوبة من الباك إند).
  /// الزائر مبيتسجلش بحثه، والتسجيل مش لازم يعطّل البحث.
  @override
  Future<void> logSearch(String query) async {
    if (!isLoggedIn) return;
    try {
      await _apiService.postData(
        endPoint: EndPoint.searchLog,
        data: {'term': _clip(query.trim(), _maxQuery)},
      );
    } catch (_) {}
  }
}