import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/spin/data/model/spin_wheel_model.dart';

/// العجلة بالقطاعات والنقوش
class WheelPainter extends CustomPainter {
  final List<SpinSection> sections;
  final double rotation;
  final double radius;

  WheelPainter({
    required this.sections,
    required this.rotation,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (sections.isEmpty) return;

    final center = size.center(Offset.zero);
    final rect = Rect.fromCircle(center: center, radius: radius);
    final seg = 2 * math.pi / sections.length;

    final fill = Paint()..style = PaintingStyle.fill;
    final border = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white
      ..strokeWidth = 2.5;
    final soft = Paint()..color = Colors.white.withValues(alpha: 0.28);

    for (int i = 0; i < sections.length; i++) {
      final start = -math.pi / 2 + i * seg + rotation;
      final mid = start + seg / 2;

      // القطاع بتدرج خفيف
      fill.shader = RadialGradient(
        colors: [
          Color.lerp(sections[i].color, Colors.black, 0.25)!,
          sections[i].color,
        ],
        stops: const [0.15, 1.0],
      ).createShader(rect);
      canvas.drawArc(rect, start, seg, true, fill);
      fill.shader = null;
      canvas.drawArc(rect, start, seg, true, border);

      // ---- النقوش ----
      // 1) حلقة رفيعة جوه الحافة
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius * 0.93),
        start + 0.05,
        seg - 0.1,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.white.withValues(alpha: 0.35)
          ..strokeWidth = 1.5,
      );

      // 2) نقط زخرفية على الحافة
      for (final f in [-0.28, 0.0, 0.28]) {
        final a = mid + seg * f;
        final p = center + Offset(math.cos(a), math.sin(a)) * radius * 0.88;
        canvas.drawCircle(p, radius * 0.018, soft);
      }

      // 3) معيّن (diamond) عند قاعدة القطاع جنب الهب
      _drawDiamond(
        canvas,
        center + Offset(math.cos(mid), math.sin(mid)) * radius * 0.33,
        radius * 0.04,
        mid,
        soft,
      );

      // 4) خطين رفيعين بيحيطوا النص
      for (final s in [-1, 1]) {
        final a = mid + s * seg * 0.33;
        canvas.drawLine(
          center + Offset(math.cos(a), math.sin(a)) * radius * 0.42,
          center + Offset(math.cos(a), math.sin(a)) * radius * 0.82,
          Paint()
            ..color = Colors.white.withValues(alpha: 0.18)
            ..strokeWidth = 1,
        );
      }

      // ---- النص ----
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(mid);
      final tp = TextPainter(
        text: TextSpan(
          text: sections[i].label,
          style: AppTextStyles.text12Bold.copyWith(fontWeight: FontWeight.w900),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 2,
        ellipsis: "...",
        textAlign: TextAlign.center,
      )..layout(maxWidth: radius * 0.5);
      tp.paint(canvas, Offset(radius * 0.42, -tp.height / 2));
      canvas.restore();
    }

    // حد خارجي للعجلة
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = const Color(0xFFFFD54F)
        ..strokeWidth = 4,
    );
  }

  void _drawDiamond(
    Canvas canvas,
    Offset c,
    double r,
    double angle,
    Paint paint,
  ) {
    final path = Path();
    for (int k = 0; k < 4; k++) {
      final a = angle + k * math.pi / 2;
      final rr = k.isEven ? r * 1.5 : r;
      final p = c + Offset(math.cos(a), math.sin(a)) * rr;
      k == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WheelPainter old) =>
      old.rotation != rotation ||
      old.radius != radius ||
      old.sections != sections;
}
