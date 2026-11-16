import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/features/spin/data/model/spin_wheel_model.dart';
import 'package:konoz/features/spin/presentation/ui/widgets/frame_painter.dart';
import 'package:konoz/features/spin/presentation/ui/widgets/wheel_painter.dart';

/// العجلة كاملة (فريم + قطاعات + مؤشر). بتتحكم فيها الشاشة بالـ [angle]
/// والـ [blink]، ومفيش state جواها.
class SpinWheelView extends StatelessWidget {
  const SpinWheelView({
    super.key,
    required this.sections,
    required this.angle,
    required this.blink,
    required this.size,
  });

  final List<SpinSection> sections;
  final double angle;
  final Animation<double> blink;
  final double size;

  static const double frameRatio = 0.14; // سمك الفريم نسبة لنصف القطر

  @override
  Widget build(BuildContext context) {
    final outerR = size / 2;
    final wheelR = outerR * (1 - frameRatio) - 4;

    return SizedBox(
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
                    animation: blink,
                    builder: (_, _) => CustomPaint(
                      size: Size(size, size),
                      painter: FramePainter(
                        blink: blink.value,
                        thicknessRatio: frameRatio,
                      ),
                    ),
                  ),
                  // العجلة
                  CustomPaint(
                    size: Size(size, size),
                    painter: WheelPainter(
                      sections: sections,
                      rotation: angle,
                      radius: wheelR,
                    ),
                  ),
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
    );
  }
}
