import 'package:equatable/equatable.dart';
import 'package:konoz/core/pagination/page_meta.dart';

/// صفحة واحدة من أي ليست: العناصر + الـ meta.
/// بتتبني من رد الـ API بدل ما كل موديل يقرا `meta` بنفسه:
///
/// ```dart
/// final page = Paginated.fromBody(res.data, OrderModel.fromJson);
/// ```
class Paginated<T> extends Equatable {
  final List<T> items;
  final PageMeta meta;

  const Paginated({required this.items, required this.meta});

  /// [itemsKey]: لو القايمة جوه `data` نفسه (زي `data.products` في /trending).
  /// من غيره بنقرا `data` كقايمة مباشرة.
  factory Paginated.fromBody(
    dynamic body,
    T Function(Map<String, dynamic>) fromJson, {
    String? itemsKey,
  }) {
    final root = body is Map ? body : const {};
    final data = root['data'];

    final Object? rows = data is List
        ? data
        : (data is Map && itemsKey != null ? data[itemsKey] : null);

    final items = (rows is List ? rows : const [])
        .whereType<Map>()
        .map((e) => fromJson(Map<String, dynamic>.from(e)))
        .toList();

    return Paginated(
      items: items,
      meta: PageMeta.fromJson(root['meta'], fallbackTotal: items.length),
    );
  }

  @override
  List<Object?> get props => [items, meta];
}
