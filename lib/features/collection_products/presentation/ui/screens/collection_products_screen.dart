import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konoz/core/pagination/load_more_listener.dart';
import 'package:konoz/features/collection_products/presentation/controllers/collection_products/collection_products_cubit.dart';
import 'package:konoz/features/collection_products/presentation/ui/widgets/collection_products_list.dart';
import 'package:konoz/features/collection_products/presentation/ui/widgets/tabs_section.dart';
import 'package:konoz/features/collections/presentation/controllers/collections/collections_cubit.dart';

class CollectionProductsScreen extends StatefulWidget {
  /// id المجموعة النصي (زي "oud")، أو '' لعرض All.
  final String collectionId;
  const CollectionProductsScreen({super.key, required this.collectionId});

  @override
  State<CollectionProductsScreen> createState() =>
      _CollectionProductsScreenState();
}

class _CollectionProductsScreenState extends State<CollectionProductsScreen> {
  @override
  void initState() {
    super.initState();
    // للتابات (بتتخطى لو متحملة)
    context.read<CollectionsCubit>().getCollections();

    // '0' كانت بتعني All في النسخة القديمة، فبنحولها لـ '' احتياطًا.
    final id = widget.collectionId == '0' ? '' : widget.collectionId;
    context.read<CollectionProductsCubit>().selectCollection(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadMoreListener(
        onLoadMore: () => context.read<CollectionProductsCubit>().loadMore(),
        child: CustomScrollView(
          slivers: [
            const TabsSection(),
            const CollectionProductsList(),
            const SliverToBoxAdapter(
              child: SafeArea(top: false, child: SizedBox.shrink()),
            ),
          ],
        ),
      ),
    );
  }
}
