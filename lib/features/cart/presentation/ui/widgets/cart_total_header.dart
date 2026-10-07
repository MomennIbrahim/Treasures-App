import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_text_rich.dart';
import 'package:konoz/features/cart/presentation/controller/cart/cart_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// "Total 5,370 L.E   Show details"
/// بيتابع الـ total من ملخص السيرفر، ولو لسه مجاش بيعرض الـ subtotal.
class CartTotalHeader extends StatelessWidget {
  const CartTotalHeader({super.key, required this.onShowDetails});

  final VoidCallback onShowDetails;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocBuilder<CartCubit, CartState>(
        // بيتبني بس لما الإجمالي أو التحميل يتغير
        buildWhen: (p, c) =>
            p.summary != c.summary ||
            p.items != c.items ||
            p.status != c.status,
        builder: (context, state) {
          final total = state.isLoading
              ? 5000
              : state.summary?.grandTotal ?? state.subtotal;

          return Skeletonizer(
            enabled: state.isLoading,
            child: Row(
              children: [
                AppRichText(
                  normalText: "${LocaleKeys.cart_total.tr()}  ",
                  normalStyle: AppTextStyles.text16Regular,
                  actionText: formatMoney(total),
                  actionStyle: AppTextStyles.text18Bold,
                ),
                const SizedBox(width: 12),
                // ملوش لازمة لو السلة فاضية
                if (state.isLoading || !state.isEmpty)
                  InkWell(
                    onTap: onShowDetails,
                    child: Container(
                      padding: paddingSymmetric(8, 4),
                      child: Text(
                        LocaleKeys.general_show_details.tr(),
                        style: AppTextStyles.text12Bold.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// 5370 → "5,370 L.E" ، و 12.5 → "12.50 L.E"
/// الأفضل تنقله لـ core/helper وتستخدمه كمان في SummaryOrderWidget.
String formatMoney(num v) {
  final text = v % 1 == 0 ? v.toInt().toString() : v.toStringAsFixed(2);
  final parts = text.split('.');
  final whole = parts.first.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  return '${parts.length > 1 ? '$whole.${parts[1]}' : whole} EGP';
}
