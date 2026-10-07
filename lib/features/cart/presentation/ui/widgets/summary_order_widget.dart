import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/cart/data/model/cart_summary_model.dart';
import 'package:konoz/features/cart/presentation/controller/cart/cart_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SummaryOrderWidget extends StatelessWidget {
  const SummaryOrderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      buildWhen: (p, c) =>
          p.summary != c.summary || p.items != c.items || p.status != c.status,
      builder: (context, state) {
        // مفيش حاجة نعرضها لو السلة فاضية
        if (!state.isLoading && (state.isEmpty || state.isFailure)) {
          return const SizedBox.shrink();
        }

        final loading = state.isLoading;
        final summary = loading
            ? CartSummaryModel.empty()
            // لو الملخص لسه مجاش (أو فشل) بنعرض الـ subtotal بس
            : state.summary ?? CartSummaryModel.fromSubtotal(state.subtotal);

        return Skeletonizer(
          enabled: loading,
          child: _SummaryCard(summary: summary),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary});
  final CartSummaryModel summary;

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
          _buildListTileSummaryOrder(
            title: LocaleKeys.cart_coast,
            value: _fmt(summary.subtotal),
          ),
          if (summary.shipping != null)
            _buildListTileSummaryOrder(
              title: LocaleKeys.cart_shipping,
              value: _fmt(summary.shipping!),
            ),
          if (summary.tax != null)
            _buildListTileSummaryOrder(
              title: LocaleKeys.cart_tax,
              value: _fmt(summary.tax!),
            ),
          if (summary.discount > 0)
            _buildListTileSummaryOrder(
              title: LocaleKeys.cart_discount,
              value: '- ${_fmt(summary.discount)}',
            ),
          const Divider(),
          _buildListTileSummaryOrder(
            title: LocaleKeys.cart_total,
            value: _fmt(summary.grandTotal),
            titleStyle: AppTextStyles.text14Bold.copyWith(
              color: AppColors.primary,
            ),
            valueStyle: AppTextStyles.text14Bold,
          ),
        ],
      ),
    );
  }

  /// 5000 → "5,000 L.E" ، و 12.5 → "12.50 L.E"
  String _fmt(num v) {
    final text = v % 1 == 0 ? v.toInt().toString() : v.toStringAsFixed(2);
    final parts = text.split('.');
    final whole = parts.first.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
    return '${parts.length > 1 ? '$whole.${parts[1]}' : whole} EGP';
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
        style: valueStyle ?? AppTextStyles.text12Regular,
      ),
    );
  }
}
