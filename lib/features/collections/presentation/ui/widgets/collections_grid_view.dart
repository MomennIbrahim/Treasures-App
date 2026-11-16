import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/features/collections/data/model/collections_model.dart';
import 'package:konoz/features/collections/presentation/ui/widgets/collection_item.dart';

class CollectionsGridView extends StatelessWidget {
  final List<CollectionsModel> collections;
  final bool isLoading;
  const CollectionsGridView({
    super.key,
    required this.collections,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: paddingAll(16),
      sliver: SliverGrid.builder(
        itemCount: isLoading ? 10 : collections.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 16.w,
        ),
        itemBuilder: (context, index) {
          final collection = isLoading
              ? collections.isNotEmpty
                    ? collections[index % collections.length]
                    : const CollectionsModel(id: "", name: 'Collection', image: '')
              : collections[index];

          return FadeIn(
            delay: Duration(milliseconds: 25 * index),
            child: CollectionItem(collection: collection),
          );
        },
      ),
    );
  }
}
