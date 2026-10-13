import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/helper/require_login.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/features/cart/presentation/controller/cart/cart_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class CurrentlyTrendingItem extends StatefulWidget {
  final ProductItemModel product;
  final bool isLoading;

  const CurrentlyTrendingItem({
    super.key,
    required this.product,
    required this.isLoading,
  });

  @override
  State<CurrentlyTrendingItem> createState() => _CurrentlyTrendingItemState();
}

class _CurrentlyTrendingItemState extends State<CurrentlyTrendingItem> {
  bool _adding = false;

  ProductItemModel get product => widget.product;
  bool get isLoading => widget.isLoading;

  Future<void> _addToCart() async {
    final sizeId = product.defaultSizeId;
    if (isLoading || _adding || sizeId == null) return;

    // لو مش مسجل دخول بيفتح الـ LoginSheet، وبيكمّل لو نجح اللوجين
    if (!await requireLogin(context)) return;
    if (!mounted) return;

    setState(() => _adding = true);
    final res = await context.read<CartCubit>().addToCart(sizeId: sizeId);
    if (!mounted) return;
    setState(() => _adding = false);

    if (res == null) return; // الضغطة اتجاهلت (فيه إضافة شغالة)

    res.fold(
      (failure) {
        AppToast.show(
          context,
          message: failure.message, // عدّلها لو اسم الحقل عندك مختلف
          type: AppToastType.error,
        );
      },
      (_) {
        AppToast.show(
          context,
          message: LocaleKeys.general_product_added_to_cart.tr(),
          type: AppToastType.success,
          onTap: () => context.go(Routes.cart),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => context.push(
        "${Routes.home}/${Routes.productDetails}",
        extra: product.id,
      ),
      child: Container(
        width: 140.w,
        decoration: BoxDecoration(
          borderRadius: AppRadius.br16,
          color: Colors.transparent,
          border: Border.all(color: colorScheme.onSurfaceVariant.withAlpha(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AppImage.cachedNetwork(
                  product.image,
                  height: 145,
                  width: double.infinity,
                  borderRadius: AppRadius.only(
                    topLeft: const Radius.circular(12),
                    bottomRight: const Radius.circular(12),
                  ),
                ),

                if (product.defaultDiscountPercentage?.isNotEmpty ?? false)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: CircleAvatar(
                      backgroundColor: isLoading
                          ? Colors.transparent
                          : AppColors.error700,
                      radius: 13.r,
                      child: Text(
                        '${product.defaultDiscountPercentage}',
                        style: AppTextStyles.text10Bold,
                      ),
                    ),
                  ),
              ],
            ),

            6.verticalSpace,

            Padding(
              padding: paddingHorizontal(8),
              child: Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.text12Bold,
              ),
            ),

            2.verticalSpace,

            Padding(
              padding: paddingHorizontal(8),
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Text(
                      '${product.defaultDiscountPrice} EGP',
                      style: AppTextStyles.text12Bold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  4.horizontalSpace,
                  Flexible(
                    child: Text(
                      product.defaultPrice,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: AppTextStyles.text12Regular.copyWith(
                        decoration: TextDecoration.lineThrough,
                        decorationColor: AppColors.primary,
                        decorationThickness: 1.8,
                        color: colorScheme.onSurfaceVariant.withAlpha(150),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            6.verticalSpace,

            Padding(
              padding: paddingHorizontal(8),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 14.sp),
                  2.horizontalSpace,
                  Expanded(
                    child: Text(
                      '${product.rating} (${product.reviewCount})',
                      style: AppTextStyles.text10Regular,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                    borderRadius: AppRadius.br48,
                    onTap:
                        (isLoading || _adding || product.defaultSizeId == null)
                        ? null
                        : _addToCart,
                    child: CircleAvatar(
                      backgroundColor: isLoading
                          ? Colors.transparent
                          : AppColors.primary.withValues(
                              alpha: product.defaultSizeId == null ? 0.4 : 0.9,
                            ),
                      radius: 14.r,
                      child: isLoading
                          ? null
                          : _adding
                          ? SizedBox(
                              width: 12.r,
                              height: 12.r,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.white,
                              ),
                            )
                          : HugeIcon(
                              icon: HugeIcons.strokeRoundedShoppingBagAdd,
                              color: AppColors.white,
                              size: 15.sp,
                              strokeWidth: 2.0,
                            ),
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
