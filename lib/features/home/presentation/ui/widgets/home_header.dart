import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  int _currentIndex = 0;
  Timer? _timer;

  final List<String> _messages = [
    'A better mood starts with KONOZ, where every fragrance is made to leave a lasting impression.',
    'Discover a fragrance that matches your personality and makes every moment feel a little more special.',
    'Your fragrance is more than just a scent, it is a signature that tells your story without saying a word.',
    'Find the perfect scent to complete your style and make your presence unforgettable wherever you go.',
    'Because the right fragrance can change your mood, boost your confidence, and make every moment memorable.',
    'Explore our collection of carefully selected fragrances and find the one that feels uniquely yours.',
    'Make every entrance memorable with a fragrance that stays with you long after you leave the room.',
    'From everyday moments to special occasions, find a scent that makes every moment worth remembering.',
    'Your perfect fragrance is waiting for you, discover new scents and find the one that feels just right.',
    'KONOZ brings you fragrances designed to express your style, elevate your mood, and leave a lasting impression.',
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
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: KeyedSubtree(
            key: ValueKey(_currentIndex),
            child: FadeInUp(
              duration: const Duration(milliseconds: 700),
              from: 20,
              curve: Curves.easeOutCubic,
              child: GradientText(
                _messages[_currentIndex],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.text14Bold,
                colors: [
                  colorScheme.onSurface,
                  AppColors.primary,
                  AppColors.primary,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
