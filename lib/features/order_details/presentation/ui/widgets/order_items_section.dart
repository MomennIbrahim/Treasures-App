
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/order_details/data/model/order_details_model.dart';
import 'package:konoz/features/order_details/presentation/ui/widgets/order_details_card.dart';
import 'package:konoz/features/order_details/presentation/ui/widgets/order_details_helpers.dart';
import 'package:konoz/features/order_details/presentation/ui/widgets/order_review_sheet.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class OrderItemsSection extends StatelessWidget {
  final List<OrderDetailsItem> items;

  /// لو null بيختفي زرار التقييم.
  final SubmitReview? onSubmitReview;

  const OrderItemsSection({
    super.key,
    required this.items,
    this.onSubmitReview,
  });

  @override
  Widget build(BuildContext context) {
    return OrderDetailsCard(
      title: LocaleKeys.cart_items.tr(),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              Divider(
                height: 20.h,
                color: AppColors.neutral500,
              ),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: SizedBox(
                    width: 56.w,
                    height: 56.w,
                    child: items[i].image.isEmpty
                        ? const Icon(Icons.image_outlined)
                        : Image.network(
                            items[i].image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                const Icon(Icons.image_not_supported_outlined),
                          ),
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        items[i].name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.text14Bold,
                      ),
                      4.verticalSpace,
                      Text(
                        'x${items[i].quantity}',
                        style: AppTextStyles.text12Regular.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
                if (items[i].total > 0)
                  Text(
                    orderMoney(items[i].total),
                    style: AppTextStyles.text14Bold,
                  ),
              ],
            ),
            if (onSubmitReview != null)
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton.icon(
                  onPressed: () {
                    showOrderReviewSheet(
                      context,
                      item: items[i],
                      onSubmit: onSubmitReview!,
                    );
                  },
                  icon: const Icon(
                    Icons.star_rate_rounded,
                    color: Colors.amber,
                  ),
                  label: Text(
                    LocaleKeys.order_details_add_review.tr(),
                    style: AppTextStyles.text12Bold,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
