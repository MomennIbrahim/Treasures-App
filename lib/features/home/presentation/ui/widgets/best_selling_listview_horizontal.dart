import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/extension/layout_builder.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/pagination/load_more_listener.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/home/presentation/ui/widgets/best_selling_item.dart';

class BestSellingListviewHorizontal extends StatelessWidget {
  final List<ProductItemModel> products;
  final bool isLoading;

  /// بيتنادى لما اليوزر يقرّب من آخر الليست
  final VoidCallback onLoadMore;

  /// loading / إعادة في آخر الليست (null = مفيش)
  final Widget? footer;

  const BestSellingListviewHorizontal({
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

    return LayoutBuilder(
      builder: (context, constrains) {
        return SizedBox(
          height: constrains.responsive(mobile: 240.h, tablet: 250.h),
          child: LoadMoreListener(
            axis: Axis.horizontal,
            threshold: 200,
            onLoadMore: onLoadMore,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: paddingHorizontal(16),
              scrollDirection: Axis.horizontal,
              itemCount: displayProducts.length + (showFooter ? 1 : 0),
              separatorBuilder: (context, index) => 10.horizontalSpace,
              itemBuilder: (context, index) {
                if (index >= displayProducts.length) return footer!;
                return BestSellingItem(
                  constraints: constrains,
                  product: displayProducts[index],
                  isLoading: isLoading,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
