import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class AppRadius {
  // Small
  static final radius4 = Radius.circular(4.r);
  static final radius8 = Radius.circular(8.r);

  // Medium
  static final radius12 = Radius.circular(12.r);

  // Large
  static final radius16 = Radius.circular(16.r);
  static final radius20 = Radius.circular(20.r);
  static final radius24 = Radius.circular(24.r);
  static final radius48 = Radius.circular(48.r);

  // BorderRadius (all corners)
  static final br4 = BorderRadius.all(radius4);
  static final br8 = BorderRadius.all(radius8);
  static final br12 = BorderRadius.all(radius12);
  static final br16 = BorderRadius.all(radius16);
  static final br20 = BorderRadius.all(radius20);
  static final br24 = BorderRadius.all(radius24);
  static final br48 = BorderRadius.all(radius48);

  // BorderRadius.only helpers
  static BorderRadius only({
    Radius topLeft = Radius.zero,
    Radius topRight = Radius.zero,
    Radius bottomLeft = Radius.zero,
    Radius bottomRight = Radius.zero,
  }) {
    return BorderRadius.only(
      topLeft: topLeft,
      topRight: topRight,
      bottomLeft: bottomLeft,
      bottomRight: bottomRight,
    );
  }

  // Shortcuts شائعة الاستخدام
  static BorderRadius top(Radius radius) =>
      BorderRadius.only(topLeft: radius, topRight: radius);

  static BorderRadius bottom(Radius radius) =>
      BorderRadius.only(bottomLeft: radius, bottomRight: radius);

  static BorderRadius left(Radius radius) =>
      BorderRadius.only(topLeft: radius, bottomLeft: radius);

  static BorderRadius right(Radius radius) =>
      BorderRadius.only(topRight: radius, bottomRight: radius);
}
