import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/helper/require_login.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/core/widgets/show_loading_dialog.dart';
import 'package:konoz/features/cart/presentation/controller/cart/cart_cubit.dart';
import 'package:konoz/features/product_details/data/model/product_details_model.dart';
import 'package:konoz/features/product_details/presentation/controllers/product_details/product_details_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class AddToCartButton extends StatelessWidget {
  final ProductDetailsModel product;
  const AddToCartButton({super.key, required this.product});

  /// [size] لازم يكون الـ label اللي السيرفر عايزه: "30 ml" / "50 ml" / "100 ml"
  Future<void> _add(BuildContext context, String size) async {
    // لو مش مسجل دخول بيفتح الـ LoginSheet، وبيكمّل لو نجح اللوجين
    if (!await requireLogin(context)) return;
    if (!context.mounted) return;
    context.read<CartCubit>().addToCart(
      productId: product.id.toString(),
      size: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocConsumer<CartCubit, CartState>(
        listenWhen: (p, c) =>
            p.actionStatus != c.actionStatus && c.action == CartAction.add,
        listener: (context, cartState) {
          switch (cartState.actionStatus) {
            case CartActionStatus.loading:
              showLoadingDialog(context);
            case CartActionStatus.success:
              hideLoadingDialog(context);
              AppToast.show(
                context,
                message: LocaleKeys.general_product_added_to_cart.tr(),
                type: AppToastType.success,
                onTap: () => context.go(Routes.cart),
              );
            case CartActionStatus.failure:
              hideLoadingDialog(context);
              AppToast.show(
                context,
                message: cartState.actionFailure?.getAllError() ?? '',
                type: AppToastType.error,
              );
            case CartActionStatus.idle:
              break;
          }
        },
        builder: (context, cartState) {
          final selectedSize = context
              .select<ProductDetailsCubit, ProductSizeModel?>(
                (c) => c.state.selectedSize,
              );
          final size = selectedSize ?? product.sizes.firstOrNull;
          final canAdd =
              !cartState.isLoading &&
              size != null &&
              size.isAvailable &&
              !cartState.isAdding;

          return AppButton(
            label: size != null && !size.isAvailable
                ? LocaleKeys.general_out_of_stock.tr()
                : LocaleKeys.general_add_to_cart.tr(),
            // displayName = "30 ml" في موديل Supabase القديم.
            // لما تتحول التفاصيل للـ API غيّرها لـ size.label
            onPressed: canAdd ? () => _add(context, size.displayName) : null,
          );
        },
      ),
    );
  }
}