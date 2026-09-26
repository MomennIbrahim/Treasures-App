import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konoz/features/collection_products/presentation/controllers/collection_products/collection_products_cubit.dart';
import 'package:konoz/features/collection_products/presentation/ui/widgets/collection_products_list.dart';
import 'package:konoz/features/collection_products/presentation/ui/widgets/tabs_section.dart';

class CollectionProductsScreen extends StatefulWidget {
  final String collectionId;
  const CollectionProductsScreen({super.key, required this.collectionId});

  @override
  State<CollectionProductsScreen> createState() =>
      _CollectionProductsScreenState();
}

class _CollectionProductsScreenState extends State<CollectionProductsScreen> {
  @override
  void initState() {
    context.read<CollectionProductsCubit>().getCollectionProducts(
      collectionId: widget.collectionId,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          TabsSection(),
          CollectionProductsList(),
          SliverToBoxAdapter(
            child: SafeArea(top: false, child: SizedBox.shrink()),
          ),
        ],
      ),
    );
  }
}
