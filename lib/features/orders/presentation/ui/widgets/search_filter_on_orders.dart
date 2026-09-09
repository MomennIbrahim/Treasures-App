import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/widgets/app_text_form_field.dart';

class SearchFilterOnOrders extends StatelessWidget {
  final ValueChanged<String>? onFilterSelected;

  const SearchFilterOnOrders({super.key, this.onFilterSelected});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: paddingHorizontal(16),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Expanded(
              child: AppTextFormField(
                hint: "Search on all orders",
                maxLines: 1,
                prefixIcon: Padding(
                  padding: paddingAll(14),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedSearch01,
                    color: AppColors.white,
                    size: 16.sp,
                  ),
                ),
              ),
            ),
            8.horizontalSpace,

            PopupMenuButton<String>(
              onSelected: (value) {
                onFilterSelected?.call(value);
              },
              color: const Color(0xFF1C1C1C),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.br8),
              offset: const Offset(0, 50),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'last_30_days',
                  child: Text(
                    'Last 30 Days',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const PopupMenuItem(
                  value: 'last_3_months',
                  child: Text(
                    'Last 3 Months',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const PopupMenuItem(
                  value: '2026',
                  child: Text('2026', style: TextStyle(color: Colors.white)),
                ),
              ],
              child: Container(
                padding: paddingAll(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24),
                  borderRadius: AppRadius.br8,
                ),
                child: Row(
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedFilter,
                      color: AppColors.white,
                      size: 20.sp,
                    ),
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      color: AppColors.white,
                      size: 20.sp,
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
