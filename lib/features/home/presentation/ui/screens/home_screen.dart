import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/home/presentation/ui/widgets/best_selling_section.dart';
import 'package:konoz/features/home/presentation/ui/widgets/currenttly_trending_section.dart';
import 'package:konoz/features/home/presentation/ui/widgets/home_header.dart';
import 'package:konoz/features/home/presentation/ui/widgets/home_offers_section.dart';
import 'package:konoz/features/home/presentation/ui/widgets/packages_section.dart';
import 'package:konoz/features/product_details/data/model/product_details_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSeeding = false;

  Future<void> _addDemoProduct() async {
    setState(() => _isSeeding = true);

    final demoProduct = ProductItemModel(
      collectionId: '6',
      name: 'Test Product ${DateTime.now().millisecondsSinceEpoch}',
      description: 'Added from the debug seeder button.',
      image: 'https://via.placeholder.com/600x600',
      rating: '4.5',
      reviewCount: '10',
      inStock: true,
      defaultSize: '50ml',
      defaultPrice: '500',
      defaultDiscountPrice: '350',
      defaultDiscountPercentage: "35%",
      isFavorite: false,
      sizes: [
        ProductSizeModel(
          id: "1",
          value: '30',
          price: '300',
          discountPrice: "250",
          discountPercentage: "35%",
          inStock: "8",
          unit: "ml",
        ),
        ProductSizeModel(
          id: "2",
          value: '50',
          price: '500',
          discountPrice: "350",
          discountPercentage: "35%",
          inStock: "12",
          unit: "ml",
        ),
        ProductSizeModel(
          id: "3",
          value: '50',
          price: '650',
          discountPrice: "5000",
          discountPercentage: "35%",
          inStock: "6",
          unit: "ml",
        ),
      ],
    );

    try {
      await ProductSeeder.addProducts([demoProduct]);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add product: $e')));
    } finally {
      if (mounted) setState(() => _isSeeding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _isSeeding ? null : _addDemoProduct,
        child: _isSeeding
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.add),
      ),
      body: Padding(
        padding: paddingOnly(bottom: 16),
        child: CustomScrollView(
          slivers: [
            HomeHeader(),
            HomeOffersSection(),
            CurrenttlyTrendingSection(),
            BestSellingSection(),
            PackagesSection(),
            const SliverToBoxAdapter(
              child: SafeArea(top: false, child: SizedBox.shrink()),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductSeeder {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> addProducts(
    List<ProductItemModel> products, {
    bool isBestSeller = false,
    bool isCurrentlyTrending = false,
  }) async {
    final batch = _firestore.batch();

    for (final product in products) {
      final docRef = _firestore.collection('products').doc();
      final json = product.toJson()
        ..['is_best_seller'] = isBestSeller
        ..['is_currently_trending'] = isCurrentlyTrending;

      batch.set(docRef, json);
    }

    await batch.commit();
  }
}
