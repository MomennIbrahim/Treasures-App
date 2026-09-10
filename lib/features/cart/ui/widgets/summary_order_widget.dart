import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class SummaryOrderWidget extends StatelessWidget {
  const SummaryOrderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: paddingVertical(16),
      padding: paddingAll(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: AppRadius.br24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.cart_summary_order.tr(),
            style: AppTextStyles.text14Bold,
          ),
          10.verticalSpace,
          _buildListTileSummaryOrder(
            title: LocaleKeys.cart_coast,
            value: "5,000 L.E",
          ),
          _buildListTileSummaryOrder(
            title: LocaleKeys.cart_shipping,
            value: "35 L.E",
          ),
          _buildListTileSummaryOrder(title: LocaleKeys.cart_tax, value: "10%"),
          _buildListTileSummaryOrder(
            title: LocaleKeys.cart_discount,
            value: "35%",
          ),
          const Divider(),
          _buildListTileSummaryOrder(
            title: LocaleKeys.cart_total,
            value: "5,350 L.E",
            titleStyle: AppTextStyles.text14Bold.copyWith(
              color: AppColors.primary,
            ),
            valueStyle: AppTextStyles.text14Bold.copyWith(
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  ListTile _buildListTileSummaryOrder({
    required String title,
    required dynamic value,
    TextStyle? titleStyle,
    TextStyle? valueStyle,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minTileHeight: 5.h,
      minVerticalPadding: 2.5.h,
      title: Text(
        title.tr(),
        style:
            titleStyle ??
            AppTextStyles.text12Regular.copyWith(color: AppColors.primary),
      ),
      trailing: Text(
        value.toString(),
        style:
            valueStyle ??
            AppTextStyles.text12Regular.copyWith(color: AppColors.white),
      ),
    );
  }
}
