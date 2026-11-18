import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/services/share_service.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/widgets/custom_back_icon.dart';
import 'package:konoz/features/product_details/data/model/product_details_model.dart';
import 'package:konoz/features/product_details/presentation/controllers/product_details/product_details_cubit.dart';
import 'package:konoz/features/product_details/presentation/ui/widgets/product_size_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'blurred_images_carousel.dart';

class ProductImagesAndSizingSection extends StatelessWidget {
  final ProductDetailsModel productDetails;

  /// صورة الكارت: بتتعرض أثناء التحميل بدل الصور الوهمية
  final String? heroImage;
  final bool isLoading;

  const ProductImagesAndSizingSection({
    super.key,
    required this.productDetails,
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

              // زرار المشاركة: في الطرف المقابل لزرار الرجوع
              PositionedDirectional(
                start: 16.w,
                bottom: 30.h,
                child: FadeInDown(
                  child: Builder(
                    builder: (btnContext) => Opacity(
                      opacity: isLoading ? 0.4 : 1,
                      child: GestureDetector(
                        onTap: isLoading
                            ? null
                            : () => ShareService.shareProduct(
                                btnContext,
                                id: productDetails.id,
                                name: productDetails.name,
                              ),
                        child: Container(
                          padding: paddingAll(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withAlpha(150),
                          ),
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedShare01,
                            color: AppColors.white,
                            size: 24.sp,
                          ),
                        ),
                      ),
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

                    final isSelected =
                        state.selectedSize?.displayName == size.displayName;

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
