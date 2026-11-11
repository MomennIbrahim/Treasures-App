import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/offer_products/data/model/mock.dart';
import 'package:konoz/features/offer_products/presentation/ui/widgets/offer_product_item.dart';

class OfferProductsScreen extends StatelessWidget {
  final List<ProductItemModel> products;
  final bool isLoading;

  const OfferProductsScreen({
    super.key,
    this.products = const [],
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
     final items = products.isEmpty ? buildMockOfferProducts() : products;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
                child: FadeInLeft(
                  child: Text(
                    "Offer Products",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
              sliver: SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  // Fixed height avoids overflow regardless of cell width.
                  mainAxisExtent: 250.h,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) => FadeInUp(
                  from: 20,
                  duration: const Duration(milliseconds: 400),
                  delay: Duration(milliseconds: (index % 6) * 70),
                  child: OfferProductItem(
                    product: items[index],
                    isLoading: isLoading,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
