import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/widgets/custom_back_icon.dart';
import 'package:konoz/features/product_details/data/model/product_details_model.dart';
import 'package:konoz/features/product_details/presentation/controllers/product_details/product_details_cubit.dart';
import 'package:konoz/features/product_details/presentation/ui/widgets/product_size_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'blurred_images_carousel.dart';

class ProductImagesAndSizingSection extends StatelessWidget {
  final ProductDetailsModel productDetails;

  /// لازم يطابق الـ tag بتاع الكارت: 'product-image-<productId>'
  final Object? heroTag;

  /// صورة الكارت: بتتعرض أثناء التحميل بدل الصور الوهمية
  final String? heroImage;
  final bool isLoading;

  const ProductImagesAndSizingSection({
    super.key,
    required this.productDetails,
    this.heroTag,
    this.heroImage,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Stack(
            children: [
              // Skeleton.ignore: عشان الـ Skeletonizer ميحوّلش الصورة لـ bones
              Skeleton.ignore(
                child: BlurredImagesCarousel(
                  height: 450.h,
                  images: (isLoading && heroImage != null)
                      ? [heroImage!]
                      : productDetails.images,
                  heroTag: heroTag,
                ),
              ),

              Positioned(
                bottom: 35.h,
                left: 35.w,
                child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                  buildWhen: (previous, current) =>
                      previous.selectedSize != current.selectedSize,
                  builder: (context, state) {
                    final selectedSize = state.selectedSize;

                    if (selectedSize == null) {
                      return const SizedBox.shrink();
                    }

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      reverseDuration: const Duration(milliseconds: 200),
                      switchInCurve: Curves.easeOutBack,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: ProductSizeItem(
                        key: ValueKey(selectedSize.id),
                        size: selectedSize,
                        isSelected: true,
                      ),
                    );
                  },
                ),
              ),

              PositionedDirectional(
                start: 16.w,
                child: SafeArea(
                  child: FadeInDown(
                    child: Container(
                      padding: paddingAll(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white24,
                      ),
                      child: CustomBackIcon(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          16.verticalSpace,
          BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
            buildWhen: (previous, current) =>
                previous.selectedSize != current.selectedSize,
            builder: (context, state) {
              return SizedBox(
                height: 40.h,
                child: ListView.separated(
                  padding: paddingHorizontal(16),
                  scrollDirection: Axis.horizontal,
                  itemCount: productDetails.sizes.length,
                  separatorBuilder: (context, index) => 10.horizontalSpace,
                  itemBuilder: (context, index) {
                    final size = productDetails.sizes[index];

                    final isSelected = state.selectedSize?.id == size.id;

                    return FadeInRight(
                      from: 30,
                      delay: Duration(milliseconds: 150 + index * 80),
                      child: ProductSizeItem(
                        size: size,
                        isSelected: isSelected,
                        onTap: () {
                          context.read<ProductDetailsCubit>().selectSize(size);
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
