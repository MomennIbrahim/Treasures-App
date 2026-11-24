import 'package:flutter/widgets.dart';

/// بيلفّ أي scrollable (ListView / CustomScrollView / GridView) وينادي
/// [onLoadMore] لما اليوزر يقرّب من آخر القايمة. من غير ScrollController.
///
/// ```dart
/// LoadMoreListener(
///   onLoadMore: () => context.read<OrdersCubit>().loadMore(),
///   child: CustomScrollView(...),   // لازم يكون ابن مباشر/غير مباشر ليه
/// )
/// ```
/// للليست الأفقية: `axis: Axis.horizontal`.
/// الـ cubit هو اللي بيمنع التكرار (`isLoadingMore` / `hasMore`).
///
/// بيشتغل في 3 حالات:
/// 1. اليوزر بيسكرول (حتى لو الـ scrollable جوه NestedScrollView/TabBarView).
/// 2. الليست اتغيّرت (صفحة اتضافت) وسه فيه مكان فاضي/قريب من الآخر.
/// 3. المحتوى أصغر من الشاشة فمفيش scroll أصلًا.
class LoadMoreListener extends StatelessWidget {
  final Widget child;
  final VoidCallback onLoadMore;

  /// اتجاه الـ scroll اللي بنراقبه (الباقي بيتتجاهل)
  final Axis axis;

  /// المسافة من آخر القايمة (بالبكسل) اللي عندها بنحمّل الصفحة التالية
  final double threshold;

  /// اطبع في الـ console كل مرة الـ listener يشتغل (للتشخيص)
  final bool debug;

  const LoadMoreListener({
    super.key,
    required this.child,
    required this.onLoadMore,
    this.axis = Axis.vertical,
    this.threshold = 300,
    this.debug = false,
  });

  bool _handle(ScrollMetrics m) {
    if (m.axis != axis) return false;
    if (debug) {
      debugPrint(
        'LoadMoreListener($axis): '
        'extentAfter=${m.extentAfter.toStringAsFixed(0)} '
        'threshold=$threshold',
      );
    }
    return m.extentAfter < threshold;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        final shouldLoad = switch (n) {
          ScrollUpdateNotification() ||
          ScrollEndNotification() ||
          OverscrollNotification() => _handle(n.metrics),
          _ => false,
        };
        if (shouldLoad) onLoadMore();
        return false; // مبنوقفش الـ notification عن حد تاني
      },
      // حالة 2 و3: الـ metrics اتغيّرت من غير حركة (صفحة اتضافت / مفيش scroll)
      child: NotificationListener<ScrollMetricsNotification>(
        onNotification: (n) {
          if (_handle(n.metrics)) {
            // بعد الفريم عشان منعملش emit وقت الـ layout
            WidgetsBinding.instance.addPostFrameCallback((_) => onLoadMore());
          }
          return false;
        },
        child: child,
      ),
    );
  }
}
