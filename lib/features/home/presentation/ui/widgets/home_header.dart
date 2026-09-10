import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/glass_icon_button.dart';
import 'package:konoz/generated/locale_keys.g.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: paddingAll(16),
        child: Row(
          children: [
            Expanded(
              child: GradientText(
                LocaleKeys.home_a_better_mood_starts_with_konooz.tr(),
                style: AppTextStyles.text16Bold,
                colors: [AppColors.white, AppColors.primary],
              ),
            ),

            10.horizontalSpace,
            GlassIconButton(
              onPressed: () {},
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedFavouriteCircle,
                strokeWidth: 1.5,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
