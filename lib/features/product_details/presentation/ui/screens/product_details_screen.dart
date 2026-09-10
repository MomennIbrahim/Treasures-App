import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_shimmer.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/core/widgets/custom_rating_widget.dart';
import 'package:konoz/features/product_details/data/demo/demo_product_details_data.dart';
import 'package:konoz/features/product_details/presentation/controllers/product_details/product_details_cubit.dart';
import 'package:konoz/features/product_details/presentation/ui/widgets/product_images_and_sizing_section.dart';
import 'package:konoz/features/product_details/presentation/ui/widgets/product_information_section.dart';
import 'package:konoz/generated/locale_keys.g.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();

    context.read<ProductDetailsCubit>().getProductDetails(productId: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
        listener: (context, state) {
          if (state.isFailure) {
            AppToast.show(
              context,
              message: "Something went wrong",
              type: AppToastType.error,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.isLoading || state.isInitial;

          final product = state.product ?? DemoProductDetailsData.product;


          return Skeletonizer(
            enabled: isLoading,
            effect: AppShimmer.effect,
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    ProductImagesAndSizingSection(productDetails: product),

                    SliverPadding(
                      padding: paddingAll(16),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: AppTextStyles.text18Bold,
                                      ),
                                      6.verticalSpace,
                                      Row(
                                        children: [
                                          CustomRatingWidget(
                                            initialRating: product.rate,
                                          ),
                                          2.horizontalSpace,
                                          Flexible(
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                "${product.rate} | 1k ${LocaleKeys.product_details_reviews.tr()}",
                                                style: AppTextStyles.text12Bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                8.horizontalSpace,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${LocaleKeys.product_details_longevity.tr()}: ${product.longevity}",
                                      style: AppTextStyles.text12Regular,
                                    ),
                                    6.verticalSpace,
                                    Text(
                                      "${LocaleKeys.product_details_sillage.tr()}: ${product.sillage}",
                                      style: AppTextStyles.text12Regular,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SliverPadding(
                      padding: paddingOnly(
                        left: 16,
                        right: 16,
                        bottom: 140,
                        top: 12,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: ProductInformationSection(product: product),
                      ),
                    ),
                  ],
                ),

                Positioned(
                  bottom: 0,
                  right: 16,
                  left: 16,
                  child: Container(
                    padding: paddingVertical(8),
                    decoration: BoxDecoration(color: AppColors.black),
                    child: SafeArea(
                      top: false,
                      child: Row(
                        children: [
                          Text(
                            "${product.sizes[0].price} L.E",
                            style: AppTextStyles.text16Bold,
                          ),
                          16.horizontalSpace,
                          Expanded(
                            child: AppButton(
                              label: LocaleKeys.general_add_to_cart.tr(),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
