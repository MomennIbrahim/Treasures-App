import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/widgets/custom_back_icon.dart';
// عدّل المسار حسب مكان الملف عندك
import 'package:konoz/features/product_details/presentation/ui/widgets/blurred_images_carousel.dart';

/// صور الباكدج (carousel بخلفية متغبشة) + زرار الرجوع.
class PackageImagesHeader extends StatelessWidget {
  final List<String> images;

  const PackageImagesHeader({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlurredImagesCarousel(height: 400.h, images: images),
        PositionedDirectional(
          start: 16.w,
          top: 48.h,
          child: FadeInDown(
            child: Container(
              padding: paddingAll(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white24,
              ),
              child: CustomBackIcon(),
            ),
          ),
        ),
      ],
    );
  }
}
