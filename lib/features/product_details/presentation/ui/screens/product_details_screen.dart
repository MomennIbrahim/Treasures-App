import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/theme/app_shimmer.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/core/widgets/custom_rating_widget.dart';
import 'package:konoz/features/product_details/data/model/product_details_model.dart';
import 'package:konoz/features/product_details/presentation/controllers/product_details/product_details_cubit.dart';
import 'package:konoz/features/product_details/presentation/ui/widgets/product_images_and_sizing_section.dart';
import 'package:konoz/features/product_details/presentation/ui/widgets/product_information_section.dart';
import 'package:konoz/generated/locale_keys.g.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;
  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductDetailsCubit>().getProductDetails(
        productId: widget.productId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
        listener: (context, state) {
          if (state.isFailure) {
            AppToast.show(
              context,
              message: LocaleKeys.errors_errors_unexpected.tr(),
              type: AppToastType.error,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.isLoading || state.isInitial;

          final product = state.product ?? ProductDetailsModel.empty();

          return Skeletonizer(
            enabled: isLoading,
            effect: AppShimmer.effect(context),
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
                                            initialRating: double.parse(
                                              product.rate.toString(),
                                            ),
                                          ),
                                          2.horizontalSpace,
                                          Flexible(
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                "${product.rate} | ${product.reviewCount} ${LocaleKeys.product_details_reviews.tr()}",
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

                _addToCartButtonAndPriceWidget(colorScheme, product, context),
              ],
            ),
          );
        },
      ),
    );
  }

  Positioned _addToCartButtonAndPriceWidget(
    ColorScheme colorScheme,
    ProductDetailsModel product,
    BuildContext context,
  ) {
    return Positioned(
      bottom: 0,
      right: 16,
      left: 16,
      child: Container(
        padding: paddingVertical(8),
        decoration: BoxDecoration(color: colorScheme.onSecondary),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                buildWhen: (previous, current) =>
                    previous.selectedSize != current.selectedSize ||
                    previous.product != current.product,
                builder: (context, state) {
                  final size = state.selectedSize ?? product.sizes.firstOrNull;
                  final price = size?.discountPrice ?? size?.price ?? '--';

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    ),
                    child: Text(
                      "$price L.E",
                      key: ValueKey(price),
                      style: AppTextStyles.text16Bold,
                    ),
                  );
                },
              ),
              16.horizontalSpace,
              Expanded(
                child: AppButton(
                  label: LocaleKeys.general_add_to_cart.tr(),
                  onPressed: () {
                    AppToast.show(
                      context,
                      message: LocaleKeys.general_product_added_to_cart.tr(),
                      type: AppToastType.success,
                      onTap: () {
                        context.go(Routes.cart);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
