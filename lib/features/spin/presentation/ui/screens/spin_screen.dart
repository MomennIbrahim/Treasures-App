import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/helper/require_login.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/core/widgets/app_loading.dart';
import 'package:konoz/core/widgets/app_text_rich.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/features/spin/data/model/spin_wheel_model.dart';
import 'package:konoz/features/spin/presentation/controllers/spin/spin_cubit.dart';
import 'package:konoz/features/spin/presentation/ui/widgets/spin_result_dialog.dart';
import 'package:konoz/features/spin/presentation/ui/widgets/spin_wheel_view.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class SpinWheelScreen extends StatefulWidget {
  const SpinWheelScreen({super.key});

  @override
  State<SpinWheelScreen> createState() => _SpinWheelScreenState();
}

class _SpinWheelScreenState extends State<SpinWheelScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller; // دوران العجلة
  late final AnimationController _blink; // وميض اللمض
  final math.Random _random = math.Random();
  double _angle = 0;
  bool _animating = false; // العجلة بتلف دلوقتي
  SpinSection? _lastPrize;

  static const double _twoPi = 2 * math.pi;

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

    context.read<SpinCubit>().getWheel();
  }

  @override
  void dispose() {
    _controller.dispose();
    _blink.dispose();
    super.dispose();
  }

  /// 1) تسجيل الدخول  2) السيرفر بيحدد الفايز  3) الأنيميشن  4) النتيجة
  Future<void> _onSpin(List<SpinSection> sections) async {
    if (_animating) return;
    if (!await requireLogin(context)) return;
    if (!mounted) return;

    final cubit = context.read<SpinCubit>();
    final winner = await cubit.spin();
    if (winner == null || !mounted) return; // الفشل بيظهر toast من الـ listener

    // الـ label واللون الأصليين من العجلة (لو رد اللف مجاش فيه تفاصيل)
    final index = sections.indexWhere((s) => s.id == winner.id);
    final prize = index >= 0 ? sections[index] : winner;

    if (index >= 0) await _animateTo(index, sections.length);
    if (!mounted) return;

    setState(() => _lastPrize = prize);
    await showSpinResultDialog(context, prize);

    // نحدّث حالة العجلة (enabled) من السيرفر بعد اللف
    if (mounted) cubit.getWheel(silent: true);
  }

  Future<void> _animateTo(int winIndex, int count) async {
    setState(() => _animating = true);
    _blink.duration = const Duration(milliseconds: 150); // لمض أسرع وقت اللف
    _blink.repeat(reverse: true);

    final double seg = _twoPi / count;
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
      _animating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = math.min(MediaQuery.of(context).size.width * 0.9, 380.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.spin_title.tr()),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: BlocListener<SpinCubit, SpinState>(
        listenWhen: (p, c) =>
            p.spinStatus != c.spinStatus &&
            c.spinStatus == SpinRequestStatus.failure,
        listener: (context, state) {
          AppToast.show(
            context,
            message: state.spinFailure?.getAllError() ?? '',
            type: AppToastType.error,
          );
        },
        child: BlocBuilder<SpinCubit, SpinState>(
          builder: (context, state) {
            // لسه بنحمّل العجلة لأول مرة / فشل التحميل
            if (state.wheel == null) {
              if (state.isFailure) return _buildError(context, state);
              return const AppLoading();
            }
            return _buildWheel(context, state, size);
          },
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, SpinState state) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(state.failure?.getAllError() ?? ''),
          TextButton(
            onPressed: () => context.read<SpinCubit>().getWheel(),
            child: Text(LocaleKeys.general_retry.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildWheel(BuildContext context, SpinState state, double size) {
    final sections = state.sections;
    final busy = _animating || state.isSpinRequesting;
    final canSpin = state.isEnabled && sections.isNotEmpty && !busy;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinWheelView(
            sections: sections,
            angle: _angle,
            blink: _blink,
            size: size,
          ),
          24.verticalSpace,
          AppButton(
            onPressed: canSpin ? () => _onSpin(sections) : null,
            icon: const Icon(Icons.casino),
            label: busy
                ? LocaleKeys.spin_spinning.tr()
                : LocaleKeys.spin_spin_button.tr(),
            buttonColor: canSpin ? AppColors.warning900 : AppColors.neutral500,
            padding: paddingSymmetric(36, 16),
          ),
          if (!state.isEnabled || sections.isEmpty) ...[
            12.verticalSpace,
            Text(
              LocaleKeys.general_not_available.tr(),
              style: AppTextStyles.text12Regular,
              textAlign: TextAlign.center,
            ),
          ],
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
    );
  }
}
