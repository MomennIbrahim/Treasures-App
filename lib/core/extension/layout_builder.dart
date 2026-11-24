import 'package:flutter/widgets.dart';

/// أقل عرض بيتعامل معاه كتابلت.
const double kTabletBreakpoint = 600;

extension ResponsiveConstraints on BoxConstraints {
  /// true لو العرض المتاح أكبر من حد التابلت.
  /// لو العرض مش محدود (parent بيدّي infinity) بنعتبره موبايل.
  bool get isTablet => maxWidth.isFinite && maxWidth > kTabletBreakpoint;

  bool get isMobile => !isTablet;

  /// اختار قيمة حسب الجهاز من غير if/else.
  T responsive<T>({required T mobile, required T tablet}) =>
      isTablet ? tablet : mobile;
}