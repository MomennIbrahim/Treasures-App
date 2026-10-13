import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AppLoading extends StatelessWidget {
  final Color color;
  final double size;
  const AppLoading({super.key , this.color = AppColors.primary,this.size = 30});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.hexagonDots(
        color: color,
        size: size.sp,
      ),
    );
  }
}
