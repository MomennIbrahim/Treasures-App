import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/core/widgets/app_text_form_field.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/features/order_details/data/model/order_details_model.dart';
import 'package:konoz/generated/locale_keys.g.dart';

/// يرجّع true لو التقييم اتبعت بنجاح.
typedef SubmitReview =
    Future<bool> Function(OrderDetailsItem item, int rating, String comment);

/// بيفتح Bottom sheet لإضافة تقييم على منتج داخل الأوردر.
Future<void> showOrderReviewSheet(
  BuildContext context, {
  required OrderDetailsItem item,
  required SubmitReview onSubmit,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => Padding(
      padding: paddingOnly(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: _OrderReviewSheet(item: item, onSubmit: onSubmit),
    ),
  );
}

class _OrderReviewSheet extends StatefulWidget {
  final OrderDetailsItem item;
  final SubmitReview onSubmit;

  const _OrderReviewSheet({required this.item, required this.onSubmit});

  @override
  State<_OrderReviewSheet> createState() => _OrderReviewSheetState();
}

class _OrderReviewSheetState extends State<_OrderReviewSheet> {
  final _controller = TextEditingController();

  int _rating = 0;
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_sending) return;

    if (_rating == 0) {
      _snack(LocaleKeys.order_details_please_choose_rating.tr());
      return;
    }

    setState(() => _sending = true);

    try {
      final ok = await widget.onSubmit(
        widget.item,
        _rating,
        _controller.text.trim(),
      );

      if (!mounted) return;

      if (ok) {
        Navigator.of(context).pop();
        AppToast.show(
          context,
          message: LocaleKeys.order_details_submitted_thank_you.tr(),
        );
      } else {
        setState(() => _sending = false);

        _snack(LocaleKeys.order_details_could_not_submit_try_again.tr());
      }
    } catch (_) {
      if (!mounted) return;

      setState(() => _sending = false);

      _snack(LocaleKeys.order_details_could_not_submit_try_again.tr());
    }
  }

  void _snack(String msg) {
    AppToast.show(context, message: msg);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: paddingOnly(left: 16.w, right: 16.w, bottom: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.order_details_rate_product.tr(),
              style: AppTextStyles.text16Bold,
            ),
            6.verticalSpace,
            Text(
              widget.item.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.text14Regular.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            12.verticalSpace,
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var star = 1; star <= 5; star++)
                    IconButton(
                      onPressed: _sending
                          ? null
                          : () => setState(() => _rating = star),
                      iconSize: 24.sp,
                      color: Colors.amber,
                      icon: Icon(
                        star <= _rating
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                      ),
                    ),
                ],
              ),
            ),
            8.verticalSpace,
            AppTextFormField(
              controller: _controller,
              enabled: !_sending,
              maxLines: 4,
              hint: LocaleKeys.order_details_write_review_optional.tr(),
            ),
            8.verticalSpace,
            AppButton(
              label: LocaleKeys.order_details_submit_review,
              onPressed: _submit,
              isLoading: _sending,
              height: 48,
            ),
          ],
        ),
      ),
    );
  }
}
