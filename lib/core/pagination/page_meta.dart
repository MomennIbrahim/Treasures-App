import 'package:equatable/equatable.dart';

/// `meta` اللي بيرجع في أي ليست فيها pagination:
/// `{current_page, last_page, per_page, total, from, to}`
///
/// ملحوظة: `per_page` ممكن يرجع "all" (لما مفيش تقسيم)، فبنقراه كـ `int?`.
class PageMeta extends Equatable {
  final int currentPage;
  final int lastPage;
  final int? perPage; // null = الكل
  final int total;

  const PageMeta({
    required this.currentPage,
    required this.lastPage,
    required this.total,
    this.perPage,
  });

  /// صفحة واحدة بس (لو الرد مفيهوش meta)
  factory PageMeta.single(int total) =>
      PageMeta(currentPage: 1, lastPage: 1, total: total);

  factory PageMeta.fromJson(dynamic json, {required int fallbackTotal}) {
    if (json is! Map) return PageMeta.single(fallbackTotal);

    int toInt(dynamic v, int fallback) =>
        v is num ? v.toInt() : (int.tryParse('${v ?? ''}') ?? fallback);

    final current = toInt(json['current_page'], 1);
    return PageMeta(
      currentPage: current,
      lastPage: toInt(json['last_page'], current),
      total: toInt(json['total'], fallbackTotal),
      perPage: int.tryParse('${json['per_page'] ?? ''}'), // "all" → null
    );
  }

  bool get hasMore => currentPage < lastPage;
  int get nextPage => currentPage + 1;

  @override
  List<Object?> get props => [currentPage, lastPage, perPage, total];
}
