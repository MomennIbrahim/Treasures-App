import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/features/cart/presentation/controller/cart/cart_cubit.dart';
import 'package:konoz/features/cart/presentation/ui/widgets/cart_items_list.dart';
import 'package:konoz/features/cart/presentation/ui/widgets/cart_total_header.dart';
import 'package:konoz/features/cart/presentation/ui/widgets/summary_order_widget.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartCubit>().getCart();
    });
  }

  final GlobalKey _summaryKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartCubit>().state.count;

    // فيه صنف واحد على الأقل مش متاح (خلص، أو الكمية أكبر من المتاح).
    final hasOutOfStock = context.select<CartCubit, bool>(
      (c) => c.state.items.any((i) => i.inStock < 1 || i.quantity > i.inStock),
    );

    return SafeArea(
      top: false,
      child: Scaffold(
        body: Padding(
          padding: paddingOnly(left: 16, right: 16, bottom: 16),
          child: CustomScrollView(
            slivers: [
              if (cartCount != 0) ...[
                CartTotalHeader(onShowDetails: _scrollToSummary),
                SliverPadding(
                  padding: paddingVertical(16),
                  sliver: SliverAppBar(
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    toolbarHeight: 42.5.h,
                    flexibleSpace: FlexibleSpaceBar(
                      background: AppButton(
                        label:
                            "${LocaleKeys.cart_proceed_to_buy.tr()} ($cartCount ${LocaleKeys.cart_items.tr()})",
                        labelStyle: AppTextStyles.text12Bold,
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          if (hasOutOfStock) {
                            AppToast.show(
                              context,
                              message: LocaleKeys.cart_out_of_stock_notice.tr(),
                              type: AppToastType.error,
                            );
                            return;
                          }
                          context.push(Routes.checkout);
                        },
                      ),
                    ),
                  ),
                ),
              ],
              CartItemsList(),
              SliverToBoxAdapter(child: SummaryOrderWidget(key: _summaryKey)),
            ],
          ),
        ),
      ),
    );
  }

  void _scrollToSummary() {
    final context = _summaryKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }
}
