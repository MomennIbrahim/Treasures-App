
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/helper/require_login.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/features/cart/presentation/controller/cart/cart_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';

// Add the imports for CartCubit, requireLogin,
// AppToast, Routes, and LocaleKeys from your project.

Future<void> addProductToCart({
  required BuildContext context,
  required int sizeId,
  required VoidCallback onLoadingStart,
  required VoidCallback onLoadingEnd,
}) async {
  // 1. Require login
  if (!await requireLogin(context)) return;

  if (!context.mounted) return;

  // 2. Start loading only after login succeeds
  onLoadingStart();

  try {
    // 3. Add product to cart
    final res = await context.read<CartCubit>().addToCart(
      sizeId: sizeId,
    );

    if (!context.mounted || res == null) return;

    // 4. Handle success and failure
    res.fold(
      (failure) {
        AppToast.show(
          context,
          message: failure.message,
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
  } finally {
    // 5. Always stop loading
    if (context.mounted) {
      onLoadingEnd();
    }
  }
}
