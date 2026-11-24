import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/core/theme/app_shimmer.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_loading.dart';
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

        // سطر زيادة في آخر القايمة: loading للصفحة التالية، أو فشلها + إعادة
        final list = state.list;
        final showFooter =
            !isLoading && (list.isLoadingMore || list.loadMoreFailure != null);

        return SliverPadding(
          padding: paddingAll(16),
          sliver: Skeletonizer.sliver(
            effect: AppShimmer.effect(context),
            enabled: isLoading,
            child: SliverList.separated(
              itemCount: products.length + (showFooter ? 1 : 0),
              separatorBuilder: (_, _) => 16.verticalSpace,
              itemBuilder: (context, index) {
                if (index >= products.length) {
                  return _Footer(
                    isLoading: list.isLoadingMore,
                    message: list.loadMoreFailure?.getAllError(),
                    onRetry: () => context
                        .read<CollectionProductsCubit>()
                        .loadMore(retry: true),
                  );
                }

                return ZoomIn(
                  // الـ key بيخلي الأنيميشن يتعاد عند تغيير التاب
                  key: ValueKey('${state.selectedCollectionId}-$index'),
                  // الدلاي على أول صفحة بس، عشان صفحات التحميل المتأخرة متستناش
                  delay: Duration(milliseconds: 25 * (index % 10)),
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

class _Footer extends StatelessWidget {
  final bool isLoading;
  final String? message;
  final VoidCallback onRetry;

  const _Footer({
    required this.isLoading,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: paddingSymmetric(0, 12),
        child: SizedBox(width: 24.w, height: 24.w, child: AppLoading()),
      );
    }

    return Column(
      children: [
        Text(
          message ?? LocaleKeys.errors_errors_unexpected.tr(),
          style: AppTextStyles.text12Regular,
          textAlign: TextAlign.center,
        ),
        TextButton(
          onPressed: onRetry,
          child: Text(LocaleKeys.general_retry.tr()),
        ),
      ],
    );
  }
}
