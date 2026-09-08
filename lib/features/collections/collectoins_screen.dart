import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: paddingHorizontal(16),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                Text(
                  "FEATURED COLLECTIONS",
                  style: AppTextStyles.text14Bold,
                  textAlign: TextAlign.center,
                ),
                4.verticalSpace,
                Text(
                  "Discover the fragrance everyone's talking about - bold, unique, and made to be your signature scent.",
                  style: AppTextStyles.text10Regular,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: paddingAll(16),
          sliver: SliverGrid.builder(
            itemCount: 10,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.h,
              crossAxisSpacing: 16.w,
            ),
            itemBuilder: (context, index) {
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
                          "https://i.pinimg.com/736x/81/98/c9/8198c9e8f9925669648e1e016f040820.jpg",
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Winter",
                          style: AppTextStyles.text16Bold.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: SafeArea(top: false, child: SizedBox.shrink()),
        ),
      ],
    );
  }
}
