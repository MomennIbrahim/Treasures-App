import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';
import 'package:konoz/features/cart/data/model/cart_item_model.dart';
import 'package:konoz/features/cart/presentation/controller/cart/cart_cubit.dart';
import 'package:konoz/features/cart/presentation/ui/widgets/empty_cart_widget.dart';
import 'package:konoz/generated/locale_keys.g.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartItemsList extends StatelessWidget {
  const CartItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      // مش محتاجين rebuild لعمليات الـ action لوحدها
      buildWhen: (p, c) =>
          p.status != c.status || p.items != c.items || p.failure != c.failure,
      builder: (context, state) {
        if (state.isFailure) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: _ErrorView(
              message: state.failure?.message ?? '',
              onRetry: () => context.read<CartCubit>().getCart(),
            ),
          );
        }

        if (!state.isLoading && state.isEmpty) {
          return EmptyCartWidget();
        }

        final items = state.isLoading
            ? List.filled(2, CartItemModel.empty())
            : state.items;

        return Skeletonizer.sliver(
          enabled: state.isLoading,
          child: SliverList.separated(
            itemCount: items.length,
            separatorBuilder: (_, _) => 15.verticalSpace,
            itemBuilder: (context, index) =>
                _CartItemCard(item: items[index], enabled: !state.isLoading),
          ),
        );
      },
    );
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({required this.item, required this.enabled});
  final CartItemModel item;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();
    final colorScheme = Theme.of(context).colorScheme;
    final inStock = item.isAvailable && !item.exceedsStock;

    return Dismissible(
      key: ValueKey('cart_item_${item.id}'),
      direction: enabled ? DismissDirection.endToStart : DismissDirection.none,
      onDismissed: (_) => cubit.removeItem(item),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: paddingAll(20),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: AppRadius.br12,
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: Container(
        padding: paddingAll(16),
        decoration: BoxDecoration(
          color: colorScheme.onSurface.withValues(alpha: 0.05),
          borderRadius: AppRadius.br12,
        ),
        child: Row(
          children: [
            Column(
              children: [
                AppImage.cachedNetwork(
                  item.image,
                  width: 100,
                  borderRadius: AppRadius.br8,
                ),
                6.verticalSpace,
                Container(
                  padding: paddingAll(8),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: AppRadius.br24,
                    border: Border.all(
                      color: AppColors.neutral500.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ActionButton(
                        icon: Icons.add,
                        onTap: enabled && item.canIncrease
                            ? () =>
                                  cubit.updateQuantity(item, item.quantity + 1)
                            : null,
                      ),
                      7.horizontalSpace,
                      Text(
                        '${item.quantity}',
                        style: AppTextStyles.text14Regular,
                      ),
                      7.horizontalSpace,
                      _ActionButton(
                        // عند 1 بيحذف العنصر
                        icon: item.quantity == 1
                            ? Icons.delete_outline
                            : Icons.remove,
                        onTap: enabled
                            ? () =>
                                  cubit.updateQuantity(item, item.quantity - 1)
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            15.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.name} ${item.sizeLabel}',
                    style: AppTextStyles.text12Bold,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  6.verticalSpace,
                  Text(
                    '${item.total.toStringAsFixed(0)} L.E',
                    style: AppTextStyles.text16Bold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.quantity > 1) ...[
                    4.verticalSpace,
                    Text(
                      '${item.unitPrice.toStringAsFixed(0)} L.E × ${item.quantity}',
                      style: AppTextStyles.text12Regular,
                    ),
                  ],
                  6.verticalSpace,
                  Text(
                    inStock
                        ? LocaleKeys.general_available.tr()
                        : LocaleKeys.general_out_of_stock.tr(),
                    style: AppTextStyles.text12Bold.copyWith(
                      color: inStock ? AppColors.success800 : colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap == null ? 0.4 : 1,
        child: Container(
          padding: paddingSymmetric(6, 3),
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.white, size: 14.sp),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.text14Regular,
          ),
          12.verticalSpace,
          TextButton(onPressed: onRetry, child: Text('general.retry'.tr())),
        ],
      ),
    );
  }
}
