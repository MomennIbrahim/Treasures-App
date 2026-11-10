import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/core/widgets/app_text_rich.dart';
import 'package:konoz/features/spin/data/model/spin_model.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class SpinWheelScreen extends StatefulWidget {
  const SpinWheelScreen({super.key, required this.brandName});

  final String brandName;

  @override
  State<SpinWheelScreen> createState() => _SpinWheelScreenState();
}

class _SpinWheelScreenState extends State<SpinWheelScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller; // دوران العجلة
  late final AnimationController _blink; // وميض اللمض
  final math.Random _random = math.Random();
  double _angle = 0;
  bool _spinning = false;
  Prize? _lastPrize;

  static const double _twoPi = 2 * math.pi;
  static const double _frameRatio = 0.14; // سمك الفريم نسبة لنصف القطر

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _blink = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _blink.dispose();
    super.dispose();
  }

  /// [forcedIndex] لو جاي من الـ backend، وإلا بيتحدد عشوائي.
  Future<void> _spin({int? forcedIndex}) async {
    if (_spinning) return;
    setState(() => _spinning = true);
    _blink.duration = const Duration(milliseconds: 150); // لمض أسرع وقت اللف

    final int winIndex = forcedIndex ?? _random.nextInt(prizes.length);
    final double seg = _twoPi / prizes.length;

    final double jitter = (_random.nextDouble() - 0.5) * seg * 0.7;
    final double desired = (_twoPi - (winIndex + 0.5) * seg + jitter) % _twoPi;
    final double current = _angle % _twoPi;
    final double extra =
        5 * _twoPi + ((desired - current) % _twoPi + _twoPi) % _twoPi;

    final double begin = _angle;
    final double end = _angle + extra;

    final animation = Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    void listener() => setState(() => _angle = animation.value);
    animation.addListener(listener);

    _controller.reset();
    await _controller.forward();
    animation.removeListener(listener);

    if (!mounted) return;

    _blink.duration = const Duration(milliseconds: 600);
    _blink.repeat(reverse: true);

    setState(() {
      _angle = end;
      _spinning = false;
      _lastPrize = prizes[winIndex];
    });
    _showResult(prizes[winIndex]);
  }

  void _showResult(Prize prize) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          LocaleKeys.spin_result_title.tr(),
          style: AppTextStyles.text16Bold,
        ),
        content: Text(
          prize.isTryAgain
              ? LocaleKeys.spin_better_luck.tr()
              : LocaleKeys.spin_you_won.tr(args: [prize.label]),
          style: AppTextStyles.text14Bold,
        ),
        actions: [
          AppButton(
            height: 35,
            onPressed: () => Navigator.pop(context),
            label: LocaleKeys.spin_ok.tr(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = math.min(MediaQuery.of(context).size.width * 0.9, 380.0);
    final outerR = size / 2;
    final wheelR = outerR * (1 - _frameRatio) - 4;
    //final hubD = wheelR * 0.42;

    return Scaffold(
      // backgroundColor: const Color(0xFF1B0B3A),
      appBar: AppBar(
        title: Text(LocaleKeys.spin_title.tr()),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size,
              height: size + 30,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Padding(
                    padding: paddingOnly(top: 30),
                    child: SizedBox(
                      width: size,
                      height: size,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // الفريم واللمض
                          AnimatedBuilder(
                            animation: _blink,
                            builder: (_, _) => CustomPaint(
                              size: Size(size, size),
                              painter: FramePainter(
                                blink: _blink.value,
                                thicknessRatio: _frameRatio,
                              ),
                            ),
                          ),
                          // العجلة
                          CustomPaint(
                            size: Size(size, size),
                            painter: WheelPainter(
                              prizes: prizes,
                              rotation: _angle,
                              radius: wheelR,
                            ),
                          ),
                          // اسم البراند في النص
                          //   _Hub(diameter: hubD, brandName: widget.brandName),
                        ],
                      ),
                    ),
                  ),
                  // المؤشر
                  Icon(
                    Icons.arrow_drop_down,
                    size: 64.sp,
                    color: const Color(0xFFFFD54F),
                  ),
                ],
              ),
            ),
            24.verticalSpace,
            AppButton(
              onPressed: _spinning ? () {} : () => _spin(),
              icon: const Icon(Icons.casino),
              label: _spinning
                  ? LocaleKeys.spin_spinning.tr()
                  : LocaleKeys.spin_spin_button.tr(),
              buttonColor: _spinning
                  ? AppColors.neutral500
                  : AppColors.warning900,
              padding: paddingSymmetric(36, 16),
            ),
            16.verticalSpace,
            if (_lastPrize != null)
              AppRichText(
                normalText: LocaleKeys.spin_last_result.tr(
                  args: [_lastPrize!.label],
                ),
                normalStyle: AppTextStyles.text14Regular.copyWith(
                  color: AppColors.white,
                ),
                actionText: ": ${_lastPrize!.label}",
                actionStyle: AppTextStyles.text14Bold.copyWith(
                  color: AppColors.success800,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// /// مركز العجلة (ثابت، مش بيلف) وعليه اسم البراند
// class _Hub extends StatelessWidget {
//   const _Hub({required this.diameter, required this.brandName});

//   final double diameter;
//   final String brandName;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: diameter,
//       height: diameter,
//       padding: EdgeInsets.all(diameter * 0.14),
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: AppColors.darkBackground,
//         border: Border.all(color: const Color(0xFFFFD54F), width: 3),
//         boxShadow: const [
//           BoxShadow(color: Colors.black54, blurRadius: 10, spreadRadius: 1),
//         ],
//       ),
//       child: FittedBox(child: Text(brandName, style: AppTextStyles.text12Bold)),
//     );
//   }
// }

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

/// العجلة بالقطاعات والنقوش
class WheelPainter extends CustomPainter {
  final List<Prize> prizes;
  final double rotation;
  final double radius;

  WheelPainter({
    required this.prizes,
    required this.rotation,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final rect = Rect.fromCircle(center: center, radius: radius);
    final seg = 2 * math.pi / prizes.length;

    final fill = Paint()..style = PaintingStyle.fill;
    final border = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white
      ..strokeWidth = 2.5;
    final soft = Paint()..color = Colors.white.withValues(alpha: 0.28);

    for (int i = 0; i < prizes.length; i++) {
      final start = -math.pi / 2 + i * seg + rotation;
      final mid = start + seg / 2;

      // القطاع بتدرج خفيف
      fill.shader = RadialGradient(
        colors: [
          Color.lerp(prizes[i].color, Colors.black, 0.25)!,
          prizes[i].color,
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
          text: prizes[i].label,
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
      old.rotation != rotation || old.radius != radius;
}
