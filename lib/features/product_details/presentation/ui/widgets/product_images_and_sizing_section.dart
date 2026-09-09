import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/widgets/app_slider.dart';
import 'package:konoz/core/widgets/custom_back_icon.dart';
import 'package:konoz/features/product_details/data/model/product_details_model.dart';
import 'package:konoz/features/product_details/presentation/controllers/product_details/product_details_cubit.dart';
import 'package:konoz/features/product_details/presentation/ui/widgets/product_size_item.dart';

class ProductImagesAndSizingSection extends StatelessWidget {
  final ProductDetailsModel productDetails;

  const ProductImagesAndSizingSection({
    super.key,
    required this.productDetails,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Stack(
            children: [
              AppSlider(
                autoScrollDuration: const Duration(seconds: 10),
                height: 325.h,
                showBannerInfo: false,
                fit: BoxFit.contain,
                items: productDetails.images
                    .map(
                      (image) => ImageBannerItem(
                        imagePath: image,
                        title: '',
                        subtitle: '',
                        buttonLabel: '',
                        onPressed: () {},
                      ),
                    )
                    .toList(),
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

                    return ProductSizeItem(
                      size: size,
                      isSelected: isSelected,
                      onTap: () {
                        context.read<ProductDetailsCubit>().selectSize(size);
                      },
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
