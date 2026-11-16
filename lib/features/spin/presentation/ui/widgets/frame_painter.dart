import 'dart:math' as math;

import 'package:flutter/material.dart';

/// الفريم الذهبي + اللمض
class FramePainter extends CustomPainter {
  final double blink; // 0..1
  final double thicknessRatio;
  static const int bulbs = 16;

  FramePainter({required this.blink, required this.thicknessRatio});

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final R = size.width / 2;
    final t = R * thicknessRatio;

    // الحلقة الذهبية
    final ringRect = Rect.fromCircle(center: c, radius: R);
    final gold = Paint()
      ..shader = const SweepGradient(
        colors: [
          Color(0xFFFFE082),
          Color(0xFFFFA000),
          Color(0xFFFFE082),
          Color(0xFFFF8F00),
          Color(0xFFFFE082),
        ],
      ).createShader(ringRect);
    canvas.drawCircle(c, R, gold);
    canvas.drawCircle(c, R - t, Paint()..color = const Color(0xFF2A1060));

    // اللمض
    final bulbR = t * 0.27;
    for (int i = 0; i < bulbs; i++) {
      final a = -math.pi / 2 + i * (2 * math.pi / bulbs);
      final p = c + Offset(math.cos(a), math.sin(a)) * (R - t / 2);
      final on = i.isEven ? blink : 1 - blink;

      // توهج
      canvas.drawCircle(
        p,
        bulbR * 1.9,
        Paint()
          ..color = const Color(0xFFFFF176).withValues(alpha: 0.65 * on)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
      );
      // اللمبة
      canvas.drawCircle(
        p,
        bulbR,
        Paint()
          ..color = Color.lerp(
            const Color(0xFF8D6E00),
            const Color(0xFFFFFDE7),
            on,
          )!,
      );
      canvas.drawCircle(
        p - Offset(bulbR * 0.3, bulbR * 0.3),
        bulbR * 0.3,
        Paint()..color = Colors.white.withValues(alpha: 0.5 + 0.4 * on),
      );
    }
  }

  @override
  bool shouldRepaint(covariant FramePainter old) => old.blink != blink;
}
