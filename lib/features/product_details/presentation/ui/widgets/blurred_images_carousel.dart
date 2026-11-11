import 'dart:async';
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/widgets/app_image.dart';

/// الصورة الحالية بتتعرض حادة في النص، وخلفها نفس الصورة
/// متغبشة (blur) وبتملا العرض كله.
class BlurredImagesCarousel extends StatefulWidget {
  final List<String> images;
  final double height;
  final Duration autoScrollDuration;

  /// لو اتحدد، أول صورة بتتغلف بـ Hero بالـ tag ده
  final Object? heroTag;

  const BlurredImagesCarousel({
    super.key,
    required this.images,
    this.height = 340,
    this.autoScrollDuration = const Duration(seconds: 10),
    this.heroTag,
  });

  @override
  State<BlurredImagesCarousel> createState() => _BlurredImagesCarouselState();
}

class _BlurredImagesCarouselState extends State<BlurredImagesCarousel> {
  final PageController _controller = PageController();
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    if (widget.images.length > 1) {
      _timer = Timer.periodic(widget.autoScrollDuration, (_) {
        if (!_controller.hasClients) return;
        final next = (_index + 1) % widget.images.length;
        _controller.animateToPage(
          next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return SizedBox(height: widget.height);

    final topInset = MediaQuery.of(context).padding.top;

    return SizedBox(
      width: double.infinity,
      height: widget.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // الخلفية المتغبشة
          ClipRect(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: SizedBox.expand(
                  key: ValueKey(_index),
                  child: AppImage.cachedNetwork(
                    widget.images[_index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          ColoredBox(color: Colors.black.withValues(alpha: 0.4)),

          // الصورة الحادة
          PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) => Padding(
              padding: EdgeInsets.fromLTRB(60.w, topInset + 24.h, 60.w, 28.h),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.35),
                      blurRadius: 30,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: _buildImage(i),
              ),
            ),
          ),

          // Indicator
          if (widget.images.length > 1)
            Positioned(
              bottom: 8.h,
              left: 0,
              right: 0,
              child: FadeInUp(
                delay: const Duration(milliseconds: 300),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.images.length, (i) {
                    final active = i == _index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: paddingHorizontal(3),
                      width: (active ? 18 : 6).w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.primary
                            : AppColors.neutral500,
                        borderRadius: AppRadius.br4,
                      ),
                    );
                  }),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImage(int i) {
    final image = AppImage.cachedNetwork(
      widget.images[i],
      fit: BoxFit.cover,
      borderRadius: AppRadius.br16,
    );
    if (i == 0 && widget.heroTag != null) {
      return Hero(tag: widget.heroTag!, child: image);
    }
    return image;
  }
}
