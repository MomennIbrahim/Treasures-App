import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/home/data/demo/demo_currently_trending_model.dart';
 import 'package:konoz/features/home/presentation/ui/widgets/best_selling_section.dart';
import 'package:konoz/features/home/presentation/ui/widgets/currenttly_trending_section.dart';
import 'package:konoz/features/home/presentation/ui/widgets/home_header.dart';
import 'package:konoz/features/home/presentation/ui/widgets/home_offers_section.dart';
import 'package:konoz/features/home/presentation/ui/widgets/packages_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _seedProducts() async {
    await ProductSeeder.addProducts(DemoCurrentlyTrendingData.demo.products);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingOnly(bottom: 16),
      child: CustomScrollView(
        slivers: [
          HomeHeader(),
          HomeOffersSection(),
          CurrenttlyTrendingSection(),
          BestSellingSection(),
          PackagesSection(),

          SliverToBoxAdapter(
            child: IconButton(
              onPressed: () async {
                await _seedProducts();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Products added successfully'),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.add),
            ),
          ),

          SliverToBoxAdapter(
            child: SafeArea(top: false, child: SizedBox.shrink()),
          ),
        ],
      ),
    );
  }
}
 
class ProductSeeder {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static Future<void> addProducts(
    List<ProductItemModel> products,
  ) async {
    final batch = _firestore.batch();

    for (final product in products) {
      final docRef = _firestore.collection('products').doc();

      batch.set(
        docRef,
        product.toJson(),
      );
    }

    await batch.commit();
  }
}