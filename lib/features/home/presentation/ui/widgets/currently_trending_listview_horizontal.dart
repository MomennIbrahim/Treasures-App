import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/pagination/load_more_listener.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/home/presentation/ui/widgets/currently_trending_item.dart';

class CurrentlyTrendingListviewHorizontal extends StatelessWidget {
  final List<ProductItemModel> products;
  final bool isLoading;

  /// بيتنادى لما اليوزر يقرّب من آخر الليست
  final VoidCallback onLoadMore;

  /// loading / إعادة في آخر الليست (null = مفيش)
  final Widget? footer;

  const CurrentlyTrendingListviewHorizontal({
    super.key,
    required this.products,
    required this.isLoading,
    required this.onLoadMore,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final displayProducts = isLoading
        ? List.generate(3, (_) => ProductItemModel.empty())
        : products;
    final showFooter = !isLoading && footer != null;

    return SizedBox(
      height: 225.h,
      child: LoadMoreListener(
        axis: Axis.horizontal,
        threshold: 200,
        onLoadMore: onLoadMore,
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: paddingHorizontal(16),
          scrollDirection: Axis.horizontal,
          itemCount: displayProducts.length + (showFooter ? 1 : 0),
          separatorBuilder: (context, index) => 8.horizontalSpace,
          itemBuilder: (context, index) {
            if (index >= displayProducts.length) return footer!;
            return CurrentlyTrendingItem(
              product: displayProducts[index],
              isLoading: isLoading,
            );
          },
        ),
      ),
    );
  }
}