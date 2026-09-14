import 'package:flutter/material.dart';
import 'package:konoz/core/widgets/app_search_bar.dart';
import 'package:konoz/features/search/presentation/ui/widgets/search_products_list.dart';

class SearchProductsScreen extends StatelessWidget {
  const SearchProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppSearchBar(showBackIcon: true, title: "Dior Sauvage"),
      body: CustomScrollView(slivers: [SearchProductsList()]),
    );
  }
}
