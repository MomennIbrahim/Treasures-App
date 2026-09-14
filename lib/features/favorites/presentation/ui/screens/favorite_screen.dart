import 'package:flutter/material.dart';
import 'package:konoz/features/favorites/presentation/ui/widgets/favorites_gridview.dart';
import 'package:konoz/features/home/data/demo/demo_currently_trending_model.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FavoritesGridview(
        products: DemoCurrentlyTrendingData.demo.products,
        isLoading: false,
      ),
    );
  }
}
