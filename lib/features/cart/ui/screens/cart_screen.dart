import 'package:flutter/material.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/features/cart/ui/widgets/cart_items_list.dart';
import 'package:konoz/features/cart/ui/widgets/summary_order_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: paddingAll(16),
        child: CustomScrollView(
          slivers: [
            CartItemsList(),
            SummaryOrderWidget(),
            // SliverToBoxAdapter(
            //   child: Column(
            //     children: [const DiscountCodeWidget(), 25.],
            //   ),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: paddingAll(20),
          child: AppButton(
            height: 50,
            label: "Checkout",
            icon: Icon(Icons.arrow_forward),
            
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
