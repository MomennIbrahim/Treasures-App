import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/constance/images_paths.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';
import 'package:konoz/core/widgets/bouncing_text.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  int _currentIndex = 0;
  Timer? _timer;

  final List<String> _messages = [
    "Spin to Win Event is live! Spin the wheel for a chance to win exciting prizes. Don’t miss out!",
  ];

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
      child: Padding(
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
                        color: AppColors.white,
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
      ),
    );
  }
}
