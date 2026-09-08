import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/collections/data/model/collections_model.dart';
 
class CollectionItem extends StatelessWidget {
  final CollectionsModel collection;

  const CollectionItem({
    super.key,
    required this.collection,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.br8,
      child: SizedBox(
        width: 120.w,
        height: 200.h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(
                collection.image,
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
              ),
            ),
            Center(
              child: Text(
                collection.name,
                style: AppTextStyles.text16Bold.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}