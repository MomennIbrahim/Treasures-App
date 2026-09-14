import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AppShimmer {
  static ShimmerEffect effect(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ShimmerEffect(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      baseColor: colorScheme.onSurface.withValues(alpha: 0.05),
      highlightColor: colorScheme.onSurface.withValues(alpha: 0.12),
    );
  }
}