import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';

class BannerItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onPressed;
  final double height;
  final bool showInfo;
  final BoxFit? boxFit;

  const BannerItem({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onPressed,
    this.height = 170,
    this.showInfo = true,
    this.boxFit,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.br12,
      child: SizedBox(
        height: height.h,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ZoomIn(
              child: AppImage.cachedNetwork(
                imagePath,
                fit: boxFit ?? BoxFit.cover,
              ),
            ),

            if (showInfo)
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.0),
                      Colors.black.withValues(alpha: 0.50),
                    ],
                  ),
                ),
              ),

            if (showInfo)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: paddingAll(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SlideInLeft(
                        child: Text(title, style: AppTextStyles.text14Bold),
                      ),
                      SlideInLeft(
                        delay: const Duration(milliseconds: 200),
                        child: Text(
                          subtitle,
                          style: AppTextStyles.text12Regular,
                        ),
                      ),
                      12.verticalSpace,
                      SlideInLeft(
                        delay: const Duration(milliseconds: 250),
                        child: Container(
                          padding: paddingSymmetric(16, 8),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: AppRadius.br24,
                          ),
                          child: Text(
                            buttonLabel,
                            style: AppTextStyles.text12Bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
