import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/constance/images_paths.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          AppImage.asset(
            ImagesPaths.emptyShopping,
            height: 50,
            width: 50,
            fit: BoxFit.contain,
          ),
          10.verticalSpace,
          Text(
            LocaleKeys.cart_empty_cart.tr(),
            style: AppTextStyles.text16Bold,
          ),
        ],
      ),
    );
  }
}
