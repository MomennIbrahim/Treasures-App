import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AppShimmer {
  static const effect = ShimmerEffect(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    baseColor: Colors.white10,
    highlightColor: Colors.white12,
  );
}
