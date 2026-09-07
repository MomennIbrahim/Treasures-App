import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/glass_icon_button.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: paddingHorizontal(16),
          child: Row(
            children: [
              Expanded(
                child: GradientText(
                  'A Better Mood Starts With KONOOZ',
                  style: AppTextStyles.text16Bold,
                  colors: [AppColors.white, AppColors.primary],
                ),
              ),
              10.horizontalSpace,
              GlassIconButton(
                onPressed: () {},
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedNotification01,
                  strokeWidth: 1.5,
                  color: Colors.white,
                ),
              ),
              10.horizontalSpace,
              GlassIconButton(
                onPressed: () {},
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedFavourite,
                  strokeWidth: 1.5,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
