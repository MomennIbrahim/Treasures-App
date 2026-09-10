import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/core/widgets/app_text_rich.dart';
import 'package:konoz/features/cart/ui/widgets/cart_items_list.dart';
import 'package:konoz/features/cart/ui/widgets/summary_order_widget.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey _summaryKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Padding(
          padding: paddingOnly(left: 16, right: 16, bottom: 16),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    AppRichText(
                      normalText: "${LocaleKeys.cart_total.tr()}  ",
                      normalStyle: AppTextStyles.text16Regular,
                      actionText: "5,370 L.E",
                      actionStyle: AppTextStyles.text18Bold,
                    ),
                    12.horizontalSpace,
                    InkWell(
                      onTap: _scrollToSummary,
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
              ),
              SliverPadding(
                padding: paddingVertical(16),
                sliver: SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.black,
                  toolbarHeight: 42.5.h,
                  flexibleSpace: FlexibleSpaceBar(
                    background: AppButton(
                      label:
                          "${LocaleKeys.cart_proceed_to_buy.tr()} (2 ${LocaleKeys.cart_items.tr()})",
                      labelStyle: AppTextStyles.text12Bold,
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
              CartItemsList(),
              SummaryOrderWidget(key: _summaryKey),

              // SliverToBoxAdapter(
              //   child: Column(
              //     children: [const DiscountCodeWidget(), 25.],
              //   ),
              // ),
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
