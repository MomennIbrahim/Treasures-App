import 'package:flutter/widgets.dart';

/// بيلفّ أي scrollable (ListView / CustomScrollView / GridView) وينادي
/// [onLoadMore] لما اليوزر يقرّب من آخر القايمة. من غير ScrollController.
///
/// ```dart
/// LoadMoreListener(
///   onLoadMore: () => context.read<OrdersCubit>().loadMore(),
///   child: CustomScrollView(...),
/// )
/// ```
/// الـ cubit هو اللي بيمنع التكرار (`isLoadingMore` / `hasMore`).
class LoadMoreListener extends StatelessWidget {
  final Widget child;
  final VoidCallback onLoadMore;

  /// المسافة من آخر القايمة (بالبكسل) اللي عندها بنحمّل الصفحة التالية
  final double threshold;

  const LoadMoreListener({
    super.key,
    required this.child,
    required this.onLoadMore,
    this.threshold = 300,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        // depth 0 = الـ scrollable الأساسي بس (مش scrollables متداخلة جواه)
        if (n.depth == 0 &&
            n is ScrollUpdateNotification &&
            n.metrics.extentAfter < threshold) {
          onLoadMore();
        }
        return false;
      },
      child: child,
    );
  }
}
