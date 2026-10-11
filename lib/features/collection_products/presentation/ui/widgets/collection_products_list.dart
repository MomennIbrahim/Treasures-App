import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/core/theme/app_shimmer.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/collection_products/presentation/controllers/collection_products/collection_products_cubit.dart';
import 'package:konoz/features/collection_products/presentation/ui/widgets/collection_product_item.dart';
import 'package:konoz/generated/locale_keys.g.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CollectionProductsList extends StatelessWidget {
  const CollectionProductsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionProductsCubit, CollectionProductsState>(
      builder: (context, state) {
        if (state.isFailure) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.failure?.getAllError() ??
                        LocaleKeys.errors_errors_unexpected.tr(),
                    style: AppTextStyles.text12Regular,
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () =>
                        context.read<CollectionProductsCubit>().retry(),
                    child: Text(LocaleKeys.general_retry.tr()),
                  ),
                ],
              ),
            ),
          );
        }

        final isLoading = state.isLoading || state.isInitial;
        final products = isLoading
            ? List.generate(4, (_) => ProductItemModel.empty())
            : state.products;

        if (products.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                LocaleKeys.collections_no_perfumes_found.tr(),
                style: AppTextStyles.text12Regular,
              ),
            ),
          );
        }

        return SliverPadding(
          padding: paddingAll(16),
          sliver: Skeletonizer.sliver(
            effect: AppShimmer.effect(context),
            enabled: isLoading,
            child: SliverList.separated(
              itemCount: products.length,
              separatorBuilder: (_, _) => 16.verticalSpace,
              itemBuilder: (context, index) {
                return ZoomIn(
                  // الـ key بيخلي الأنيميشن يتعاد عند تغيير التاب
                  key: ValueKey('${state.selectedCollectionId}-$index'),
                  delay: Duration(milliseconds: 25 * index),
                  child: CollectionProductItem(
                    product: products[index],
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
