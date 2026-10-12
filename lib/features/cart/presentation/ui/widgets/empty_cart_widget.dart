import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/constance/images_paths.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: paddingVertical(16),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            AppImage.asset(
              ImagesPaths.emptyShopping,
              height: 90,
              width: 90,
              fit: BoxFit.contain,
            ),
            24.verticalSpace,
            Text(
              LocaleKeys.cart_empty_cart.tr(),
              style: AppTextStyles.text14Regular.copyWith(height: 1.4),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
