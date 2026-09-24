import 'package:flutter/material.dart';
import 'package:konoz/features/favorites/presentation/ui/widgets/favorites_gridview.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: FavoritesGridview(products: [], isLoading: false));
  }
}
