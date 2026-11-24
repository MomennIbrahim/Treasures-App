import 'package:equatable/equatable.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/pagination/page_meta.dart';
import 'package:konoz/core/pagination/paginated.dart';

/// حالة الليست المتقسّمة، بتتحط كـ field جوه أي State بدل `List<T>`:
///
/// ```dart
/// final PagedList<OrderModel> orders;   // بدل List<OrderModel>
/// ```
class PagedList<T> extends Equatable {
  final List<T> items;
  final PageMeta? meta; // null = لسه ما اتحمّلتش أول صفحة
  final bool isLoadingMore;

  /// فشل تحميل الصفحة التالية (القايمة الحالية بتفضل ظاهرة)
  final AppFailure? loadMoreFailure;

  const PagedList({
    this.items = const [],
    this.meta,
    this.isLoadingMore = false,
    this.loadMoreFailure,
  });

  bool get hasMore => meta?.hasMore ?? false;
  int get nextPage => meta?.nextPage ?? 1;
  int get total => meta?.total ?? items.length;
  bool get isEmpty => items.isEmpty;

  /// أول صفحة (أو refresh): بتبدّل القايمة كلها
  PagedList<T> first(Paginated<T> page) =>
      PagedList(items: page.items, meta: page.meta);

  /// الصفحة التالية: بتتضاف تحت اللي موجود
  PagedList<T> appended(Paginated<T> page) =>
      PagedList(items: [...items, ...page.items], meta: page.meta);

  PagedList<T> loadingMore() =>
      PagedList(items: items, meta: meta, isLoadingMore: true);

  PagedList<T> loadMoreFailed(AppFailure failure) =>
      PagedList(items: items, meta: meta, loadMoreFailure: failure);

  /// تعديل عنصر محليًا (مثلًا حالة أوردر اتغيرت) من غير ما نلمس الصفحات
  PagedList<T> mapItems(T Function(T item) transform) => PagedList(
    items: [for (final i in items) transform(i)],
    meta: meta,
    isLoadingMore: isLoadingMore,
    loadMoreFailure: loadMoreFailure,
  );

  @override
  List<Object?> get props => [items, meta, isLoadingMore, loadMoreFailure];
}
