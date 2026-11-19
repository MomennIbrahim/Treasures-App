import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/features/order_details/data/model/order_details_model.dart';
import 'package:konoz/features/order_details/presentation/controllers/order_details/order_details_cubit.dart';
import 'package:konoz/features/order_details/presentation/ui/widgets/order_details_card.dart';
import 'package:konoz/features/order_details/presentation/ui/widgets/order_details_helpers.dart';
import 'package:konoz/features/orders/data/model/order_model.dart';
import 'package:konoz/generated/locale_keys.g.dart';

List<List<dynamic>> _stepIcon(OrderStatus s) => switch (s) {
  OrderStatus.pending => HugeIcons.strokeRoundedInvoice01,
  OrderStatus.confirmed => HugeIcons.strokeRoundedPackage,
  OrderStatus.shipped => HugeIcons.strokeRoundedTruckDelivery,
  OrderStatus.delivered => HugeIcons.strokeRoundedHome01,
  OrderStatus.cancelled => HugeIcons.strokeRoundedCancelCircle,
};

class OrderTrackingSection extends StatelessWidget {
  final List<TrackingStep> steps;
  const OrderTrackingSection({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    // المرحلة الحالية = آخر مرحلة وصلها الأوردر
    final current = steps.lastIndexWhere((s) => s.done);

    return OrderDetailsCard(
      title: LocaleKeys.checkout_track_order.tr(),
      child: Column(
        children: [
          for (var i = 0; i < steps.length; i++)
            _StepRow(
              step: steps[i],
              isCurrent: i == current,
              isDone: i < current, // مرحلة عدّت
              isLast: i == steps.length - 1,
              // الخط بعد المرحلة بيتلوّن لو الأوردر عدّاها
              lineActive: i < current,
            ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final TrackingStep step;
  final bool isCurrent;
  final bool isDone;
  final bool isLast;
  final bool lineActive;

  const _StepRow({
    required this.step,
    required this.isCurrent,
    required this.isDone,
    required this.isLast,
    required this.lineActive,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final activeColor = step.status == OrderStatus.cancelled
        ? AppColors.error700
        : AppColors.success800;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 44.w,
            child: Column(
              children: [
                _StepBadge(
                  icon: _stepIcon(step.status),
                  isCurrent: isCurrent,
                  isDone: isDone,
                  color: activeColor,
                ),
                if (!isLast)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: CustomPaint(
                        size: const Size(2, double.infinity),
                        painter: _DashedLinePainter(
                          color: lineActive
                              ? AppColors.success800
                              : scheme.outlineVariant,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 10.h, bottom: isLast ? 0 : 22.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderStatusText(step.status),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                      color: isCurrent
                          ? activeColor
                          : (isDone ? null : scheme.outline),
                    ),
                  ),
                  if (step.at != null)
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Text(
                        '${step.at!.day}/${step.at!.month}/${step.at!.year}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: scheme.outline,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepBadge extends StatelessWidget {
  final List<List<dynamic>> icon;
  final bool isCurrent;
  final bool isDone;
  final Color color;

  const _StepBadge({
    required this.icon,
    required this.isCurrent,
    required this.isDone,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLoading = context.watch<OrderDetailsCubit>().state.isLoading;

    // الحالية: أخضر ممتلئ | عدّت: أخضر فاتح | لسه: رمادي
    final Color bg = isCurrent
        ? color
        : isDone
        ? AppColors.success800.withValues(alpha: 0.12)
        : scheme.surfaceContainerHighest;
    final Color fg = isCurrent
        ? Colors.white
        : isDone
        ? AppColors.success800
        : scheme.outline;

    return Container(
      width: 38.w,
      height: 38.w,
      decoration: BoxDecoration(
        color: isLoading ? AppColors.neutral500.withValues(alpha: 0.2) : bg,
        shape: BoxShape.circle,
        boxShadow: isLoading
            ? null
            : isCurrent
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.35),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Center(
        child: HugeIcon(icon: icon, size: 18.sp, color: fg),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const dash = 5.0;
    const gap = 4.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final x = size.width / 2;
    var y = 0.0;
    while (y < size.height) {
      final end = (y + dash).clamp(0.0, size.height);
      canvas.drawLine(Offset(x, y), Offset(x, end), paint);
      y += dash + gap;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) => old.color != color;
}
