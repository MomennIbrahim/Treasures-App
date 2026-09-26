import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/core/theme/app_shimmer.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/features/collection_products/presentation/controllers/collection_products/collection_products_cubit.dart';
import 'package:konoz/features/collection_products/presentation/ui/widgets/collection_product_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CollectionProductsList extends StatelessWidget {
  const CollectionProductsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CollectionProductsCubit, CollectionProductsState>(
      listener: (context, state) {
        if (state.isFailure && state.failure != null) {
          AppToast.show(context, message: state.failure?.getAllError() ?? '');
        }
      },
      builder: (context, state) {
        final isLoading = state.isLoading;

        final displayProducts = isLoading
            ? List.generate(4, (_) => ProductItemModel.empty())
            : state.products;

        if (displayProducts.isEmpty && !isLoading) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        return SliverPadding(
          padding: paddingAll(16),
          sliver: Skeletonizer.sliver(
            effect: AppShimmer.effect(context),
            enabled: isLoading,
            child: SliverList.separated(
              itemCount: displayProducts.length,
              separatorBuilder: (context, index) => 16.verticalSpace,
              itemBuilder: (context, index) {
                return ZoomIn(
                  delay: Duration(milliseconds: 25 * index),
                  child: CollectionProductItem(
                    product: displayProducts[index],
                    isLoading: isLoading,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
