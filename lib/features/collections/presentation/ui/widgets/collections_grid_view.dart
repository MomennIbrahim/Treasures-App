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
                    : const CollectionsModel(
                        id: 0,
                        name: 'Collection',
                        description: '',
                        image:
                            'https://i.pinimg.com/736x/81/98/c9/8198c9e8f9925669648e1e016f040820.jpg',
                      )
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
