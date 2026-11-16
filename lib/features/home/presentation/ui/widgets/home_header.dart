import 'dart:async';

import 'package:animate_do/animate_do.dart' hide SpinState;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/constance/images_paths.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';
import 'package:konoz/core/widgets/bouncing_text.dart';
import 'package:konoz/features/spin/presentation/controllers/spin/spin_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  int _currentIndex = 0;
  Timer? _timer;

  final List<String> _messages = [LocaleKeys.spin_event_banner.tr()];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!mounted) return;

      setState(() {
        _currentIndex = (_currentIndex + 1) % _messages.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverToBoxAdapter(
      child: BlocBuilder<SpinCubit, SpinState>(
        builder: (context, state) {
          if (state.isInitial || state.isLoading || !state.isEnabled) {
            return SizedBox.shrink();
          }

          return Padding(
            padding: paddingSymmetric(16, 8),
            child: KeyedSubtree(
              key: ValueKey(_currentIndex),
              child: FadeInUp(
                duration: const Duration(milliseconds: 700),
                from: 20,
                curve: Curves.easeOutCubic,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppImage.asset(ImagesPaths.luckyWheel, width: 32),
                    8.horizontalSpace,
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: BouncingText(
                          _messages[_currentIndex],
                          style: AppTextStyles.text14Bold.copyWith(
                            color: colorScheme.onSurface,
                          ),
                          highlightColor: AppColors.primary, // أو أي لون تحبه
                          interval: const Duration(seconds: 6),
                          bounceHeight: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
