import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/core/widgets/app_loading.dart';
import 'package:konoz/core/widgets/app_search_bar.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/core/widgets/custom_rating_widget.dart';
import 'package:konoz/features/product_details/presentation/controllers/product_details/product_details_cubit.dart';
import 'package:konoz/features/product_details/presentation/ui/widgets/product_images_and_sizing_section.dart';
import 'package:konoz/features/product_details/presentation/ui/widgets/product_information_section.dart';

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
      appBar: AppSearchBar(showBackIcon: true),
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
          if (state.isLoading) {
            return AppLoading();
          }
          if (state.product == null) {
            return const SizedBox.shrink();
          }

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  ProductImagesAndSizingSection(productDetails: state.product!),
                  SliverPadding(
                    padding: paddingAll(16),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.product!.name,
                                      style: AppTextStyles.text18Bold,
                                    ),
                                    6.verticalSpace,
                                    Row(
                                      children: [
                                        CustomRatingWidget(
                                          initialRating: state.product!.rate,
                                        ),
                                        2.horizontalSpace,
                                        Text(
                                          state.product!.rate.toString(),
                                          style: AppTextStyles.text12Bold,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Longevity: ${state.product!.longevity}",
                                    style: AppTextStyles.text12Regular,
                                  ),
                                  6.verticalSpace,
                                  Text(
                                    "Sillage: ${state.product!.sillage}",
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
                    padding: paddingOnly(left: 16, right: 16, bottom: 115),
                    sliver: SliverToBoxAdapter(
                      child: ProductInformationSection(product: state.product!),
                    ),
                  ),
                ],
              ),

              Positioned(
                bottom: 16.0,
                right: 16.0,
                left: 16.0,
                child: SafeArea(
                  child: Container(
                    padding: paddingVertical(8),
                    decoration: BoxDecoration(color: Colors.black),
                    child: Row(
                      children: [
                        Text(
                          "${state.product!.sizes[0].price} L.E",
                          style: AppTextStyles.text16Bold,
                        ),
                        16.horizontalSpace,
                        Expanded(
                          child: AppButton(
                            label: "Add to cart",
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
