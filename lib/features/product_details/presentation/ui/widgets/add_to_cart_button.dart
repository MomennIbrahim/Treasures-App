import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocConsumer<CartCubit, CartState>(
        listenWhen: (p, c) => p.actionStatus != c.actionStatus,
        listener: (context, cartState) {
          if (cartState.actionStatus == CartActionStatus.loading) {
            showLoadingDialog(context);
          }

          if (cartState.actionStatus == CartActionStatus.success) {
            hideLoadingDialog(context);
            AppToast.show(
              context,
              message: LocaleKeys.general_product_added_to_cart.tr(),
              type: AppToastType.success,
              onTap: () => context.go(Routes.cart),
            );
          } else if (cartState.isFailure) {
            hideLoadingDialog(context);
            AppToast.show(
              context,
              message: cartState.failure?.getAllError() ?? '',
              type: AppToastType.error,
            );
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
            onPressed: canAdd
                ? () => context.read<CartCubit>().addToCart(
                    sizeId: int.parse(size.id),
                  )
                : null,
          );
        },
      ),
    );
  }
}
