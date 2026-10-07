import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/core/widgets/show_blurred_confirmation_dialog.dart';
import 'package:konoz/core/widgets/show_loading_dialog.dart';
import 'package:konoz/features/cart/presentation/controller/cart/cart_cubit.dart';
import 'package:konoz/features/cart/presentation/ui/widgets/cart_total_header.dart'; // formatMoney
import 'package:konoz/features/cart/presentation/ui/widgets/summary_order_widget.dart';
import 'package:konoz/features/checkout/data/model/checkout_model.dart';
import 'package:konoz/features/checkout/presentation/controllers/checkout/checkout_cubit.dart';
import 'package:konoz/features/checkout/presentation/ui/widgets/checkout_address_section.dart';
import 'package:konoz/features/checkout/presentation/ui/widgets/payment_methods_section.dart';
import 'package:konoz/features/profile/presentation/controllers/profile/profile_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<CheckoutCubit, CheckoutState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.isLoading) {
          showLoadingDialog(context);
          return;
        }
        hideLoadingDialog(context);

        if (state.isFailure) {
          AppToast.show(
            context,
            message: state.failure?.message ?? '',
            type: AppToastType.error,
          );
        } else if (state.isSuccess && state.order != null) {
          _showSuccessDialog(context, state.order!);
        }
      },
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: colorScheme.onSecondary,
                title: Text(
                  LocaleKeys.checkout_checkout.tr(),
                  style: AppTextStyles.text18Bold,
                ),
              ),
              SliverPadding(
                padding: paddingAll(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _sectionTitle(LocaleKeys.checkout_delivery_address),
                    10.verticalSpace,
                    const CheckoutAddressSection(),
                    24.verticalSpace,
                    const PaymentMethodSection(),
                    24.verticalSpace,
                    _sectionTitle(LocaleKeys.cart_summary_order),
                    const SummaryOrderWidget(),
                  ]),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            padding: paddingOnly(left: 16, right: 16, top: 12, bottom: 16),
            decoration: BoxDecoration(color: colorScheme.onSecondary),
            child: BlocSelector<CartCubit, CartState, num>(
              selector: (s) => s.summary?.grandTotal ?? s.subtotal,
              builder: (context, total) => AppButton(
                label:
                    '${LocaleKeys.checkout_place_order.tr()} - ${formatMoney(total)}',
                labelStyle: AppTextStyles.text14Bold,
                icon: const Icon(Icons.arrow_forward),
                onPressed: () => _placeOrder(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) =>
      Text(title.tr(), style: AppTextStyles.text16Bold);

  void _placeOrder(BuildContext context) {
    final cart = context.read<CartCubit>().state;
    if (cart.isEmpty || cart.hasStockIssue) {
      AppToast.show(
        context,
        message: 'checkout.cart_has_issues'.tr(),
        type: AppToastType.error,
      );
      return;
    }

    final checkout = context.read<CheckoutCubit>();
    final profile = context.read<ProfileCubit>().state.profile;
    final address = resolveCheckoutAddress(
      profile?.addresses ?? const [],
      checkout.state.selectedAddressId,
    );

    if (address == null) {
      AppToast.show(
        context,
        message: 'checkout.select_address'.tr(),
        type: AppToastType.error,
      );
      return;
    }

    checkout.placeOrder(addressId: int.parse(address.id.toString()));
  }

  void _showSuccessDialog(BuildContext context, PlacedOrderModel order) {
    showBlurredConfirmationDialog(
      context: context,
      barrierDismissible: false,
      title: LocaleKeys.checkout_order_placed_successfully.tr(),
      message: LocaleKeys.checkout_order_placed_message.tr(
        args: [order.orderId.toString()],
      ),
      confirmText: LocaleKeys.checkout_track_order.tr(),
      secondaryText: LocaleKeys.checkout_continue_shopping.tr(),
      confirmColor: AppColors.primary,
      onConfirm: () => context.go("${Routes.profile}/${Routes.orders}"),
      onSecondary: () => context.go(Routes.home),
    );
  }
}
