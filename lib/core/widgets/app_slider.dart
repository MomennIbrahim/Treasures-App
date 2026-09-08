import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/features/home/presentation/ui/widgets/banner_Item.dart';

class AppSlider extends StatefulWidget {
  final List<ImageBannerItem> items;
  final double height;
  final Duration autoScrollDuration;
  final bool showBannerInfo;
  final BoxFit? fit;

  const AppSlider({
    super.key,
    required this.items,
    this.height = 170,
    this.autoScrollDuration = const Duration(seconds: 4),
    this.showBannerInfo = true,
    this.fit,
  });

  @override
  State<AppSlider> createState() => _AppSliderState();
}

class _AppSliderState extends State<AppSlider> {
  late final PageController _controller;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    if (widget.items.length > 1) _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(widget.autoScrollDuration, (_) {
      if (!_controller.hasClients) return;

      final nextPage = (_currentPage + 1) % widget.items.length;
      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: widget.height.h,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.items.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return BannerItem(
                showInfo: widget.showBannerInfo,
                boxFit: widget.fit,
                imagePath: item.imagePath,
                title: item.title,
                subtitle: item.subtitle,
                buttonLabel: item.buttonLabel,
                onPressed: item.onPressed,
                height: widget.height,
              );
            },
          ),
        ),
        if (widget.items.length > 1) ...[
          10.verticalSpace,
          _Indicators(count: widget.items.length, currentIndex: _currentPage),
        ],
      ],
    );
  }
}

class _Indicators extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _Indicators({required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: paddingHorizontal(3),
          width: isActive ? 22.w : 7.w,
          height: 7.h,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary
                : AppColors.white.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(3.r),
          ),
        );
      }),
    );
  }
}

class ImageBannerItem {
  final String imagePath;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onPressed;

  const ImageBannerItem({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onPressed,
  });
}
