import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/core/widgets/show_blurred_confirmation_dialog.dart';
import 'package:konoz/features/cart/ui/widgets/summary_order_widget.dart';
import 'package:konoz/features/checkout/presentation/ui/widgets/address_card.dart';
import 'package:konoz/features/checkout/presentation/ui/widgets/payment_methods.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final int _selectedPayment = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.black,
              title: Text('Checkout', style: AppTextStyles.text18Bold),
            ),

            SliverPadding(
              padding: paddingAll(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildSectionTitle(LocaleKeys.checkout_delivery_address),
                  10.verticalSpace,
                  AddressCard(),
                  24.verticalSpace,
                  PaymentMethodSection(),
                  24.verticalSpace,
                  _buildSectionTitle(LocaleKeys.cart_summary_order),
                  10.verticalSpace,
                  SummaryOrderWidget(),
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
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border(top: BorderSide(color: Colors.white12)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppButton(
                label: '${LocaleKeys.checkout_place_order.tr()} - 5,350 L.E',
                labelStyle: AppTextStyles.text14Bold,
                icon: const Icon(Icons.arrow_forward),
                onPressed: _placeOrder,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title.tr(), style: AppTextStyles.text16Bold);
  }

  void _placeOrder() {
    showBlurredConfirmationDialog(
      context: context,
      barrierDismissible: false,
      title: 'Order Placed Successfully',
      message: 'Your order has been placed successfully.',
      confirmText: 'Track Order',
      secondaryText: 'Continue Shopping',
      confirmColor: AppColors.primary,

      onConfirm: () {
        context.go("${Routes.profile}/${Routes.orders}");
      },

      onSecondary: () {
        context.go(Routes.home);
      },
    );
  }
}
