import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';

class SummaryOrderWidget extends StatelessWidget {
  const SummaryOrderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: paddingVertical(16),
        padding: paddingAll(16),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: AppRadius.br24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Summary Order", style: AppTextStyles.text14Bold),
            10.verticalSpace,
            _buildListTileSummaryOrder(title: "Coast", value: "5000 L.E"),
            _buildListTileSummaryOrder(title: "Shipping", value: "35 L.E"),
            _buildListTileSummaryOrder(title: "Tax", value: "10%"),
            _buildListTileSummaryOrder(
              title: "Discount",
              value: "35%",
              titleStyle: AppTextStyles.text14Regular.copyWith(
                color: AppColors.primary,
              ),
            ),
            const Divider(),
            _buildListTileSummaryOrder(
              title: "Total",
              value: "5350 L.E",
              titleStyle: AppTextStyles.text14Bold.copyWith(
                color: AppColors.primary,
              ),
              valueStyle: AppTextStyles.text14Bold.copyWith(
                color: AppColors.white,
              ),
            ),
          ],
        ),
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
        title,
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
