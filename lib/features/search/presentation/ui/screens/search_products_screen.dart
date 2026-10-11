import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/core/widgets/app_search_bar.dart';
import 'package:konoz/features/search/presentation/controllers/search/search_cubit.dart';
import 'package:konoz/features/search/presentation/ui/widgets/search_product_item.dart';
import 'package:konoz/generated/locale_keys.g.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchProductsScreen extends StatelessWidget {
  const SearchProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final query = context.select<SearchCubit, String>((c) => c.state.query);

    return Scaffold(
      appBar: AppSearchBar(showBackIcon: true, title: query),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state.isFailure) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.failure?.message ?? ''),
                  TextButton(
                    onPressed: () => context.read<SearchCubit>().retry(),
                    child: Text(LocaleKeys.errors_too_many_requests.tr()),
                  ),
                ],
              ),
            );
          }

          if (state.isLoading) {
            return Skeletonizer(
              child: ListView.separated(
                padding: paddingAll(16),
                itemCount: 4,
                separatorBuilder: (_, _) => 12.verticalSpace,
                itemBuilder: (_, _) => SearchProductItem(
                  product: ProductItemModel.empty(),
                  isLoading: true,
                ),
              ),
            );
          }

          if (state.products.isEmpty) {
            return Center(child: Text(LocaleKeys.general_search_hint.tr()));
          }

          return ListView.separated(
            padding: paddingAll(16),
            itemCount: state.products.length,
            separatorBuilder: (_, _) => 12.verticalSpace,
            itemBuilder: (_, i) =>
                SearchProductItem(product: state.products[i], isLoading: false),
          );
        },
      ),
    );
  }
}