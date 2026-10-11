import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_text_form_field.dart';
import 'package:konoz/features/orders/data/model/orders_filter.dart';
import 'package:konoz/features/orders/presentation/controllers/orders_cubit.dart';
 
import 'package:konoz/generated/locale_keys.g.dart';

class SearchFilterOnOrders extends StatelessWidget {
  const SearchFilterOnOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.read<OrdersCubit>();

    return SliverPadding(
      padding: paddingHorizontal(16),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Expanded(
              child: AppTextFormField(
                hint: LocaleKeys.orders_search_hint.tr(),
                maxLines: 1,
                onChanged: cubit.onSearchChanged,
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
            PopupMenuButton<OrdersFilter>(
              onSelected: cubit.setFilter,
              color: colorScheme.surface,
              surfaceTintColor: Colors.transparent,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.br8),
              offset: const Offset(0, 50),
              itemBuilder: (context) {
                final selected = cubit.state.filter;
                return [
                  for (final f in OrdersFilter.values)
                    PopupMenuItem(
                      value: f,
                      child: Text(
                        f.name,
                        style: AppTextStyles.text12Regular.copyWith(
                          color: f == selected
                              ? AppColors.primary
                              : colorScheme.onSurface,
                        ),
                      ),
                    ),
                ];
              },
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