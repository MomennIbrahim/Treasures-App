import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_text_form_field.dart';

class SearchFilterOnOrders extends StatelessWidget {
  final ValueChanged<String>? onFilterSelected;

  const SearchFilterOnOrders({super.key, this.onFilterSelected});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
                    size: 16.sp,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            8.horizontalSpace,
            PopupMenuButton<String>(
              onSelected: (value) {
                onFilterSelected?.call(value);
              },
              color: colorScheme.surface,
              surfaceTintColor: Colors.transparent,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.br8),
              offset: const Offset(0, 50),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'last_30_days',
                  child: Text(
                    'Last 30 Days',
                    style: AppTextStyles.text12Regular.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'last_3_months',
                  child: Text(
                    'Last 3 Months',
                    style: AppTextStyles.text12Regular.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: '2026',
                  child: Text(
                    '2026',
                    style: AppTextStyles.text12Regular.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
              child: Container(
                padding: paddingAll(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  borderRadius: AppRadius.br8,
                ),
                child: Row(
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedFilter,
                      size: 20.sp,
                      color: colorScheme.onSurface,
                    ),
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      size: 20.sp,
                      color: colorScheme.onSurface,
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
