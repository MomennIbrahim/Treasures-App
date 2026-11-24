import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/features/order_details/data/model/order_details_model.dart';
import 'package:konoz/features/order_details/data/model/refund_model.dart';
import 'package:konoz/generated/locale_keys.g.dart';

/// الإرجاع بالمنتجات بس: البنود المختارة + السبب.
typedef RefundRequestData = ({String reason, List<RefundItemSelection> items});

/// بيرجّع null لو اليوزر قفل الشيت من غير ما يبعت.
Future<RefundRequestData?> showRefundRequestSheet(
  BuildContext context, {
  required int refundable,
  required List<OrderDetailsItem> items,
}) {
  return showModalBottomSheet<RefundRequestData>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _RefundRequestSheet(refundable: refundable, items: items),
  );
}

class _RefundRequestSheet extends StatefulWidget {
  final int refundable;
  final List<OrderDetailsItem> items;
  const _RefundRequestSheet({required this.refundable, required this.items});

  @override
  State<_RefundRequestSheet> createState() => _RefundRequestSheetState();
}

class _RefundRequestSheetState extends State<_RefundRequestSheet> {
  static const _maxReason = 1000;

  final _formKey = GlobalKey<FormState>();
  final _reason = TextEditingController();

  bool _selectError = false;

  /// order_item_id → الكمية المختارة
  final Map<int, int> _qty = {};

  /// البنود اللي ليها كمية متاحة للإرجاع
  late final List<OrderDetailsItem> _selectable = widget.items
      .where((i) => i.id != 0 && i.refundableQuantity > 0)
      .toList();

  /// تقدير بس: السيرفر هو اللي بيحسب (سعر الوحدة × الكمية)
  int get _estimate => _selectable.fold(
    0,
    (sum, i) => sum + (i.unitPrice * (_qty[i.id] ?? 0)).toInt(),
  );

  bool get _hasSelection => _qty.values.any((q) => q > 0);
  bool get _overLimit => _estimate > widget.refundable;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  String? _validateReason(String? v) =>
      (v ?? '').trim().isEmpty ? LocaleKeys.refund_reason_required.tr() : null;

  void _setQty(OrderDetailsItem item, int value) {
    setState(() {
      _selectError = false;
      final v = value.clamp(0, item.refundableQuantity);
      if (v == 0) {
        _qty.remove(item.id);
      } else {
        _qty[item.id] = v;
      }
    });
  }

  void _submit() {
    final reasonOk = _formKey.currentState?.validate() ?? false;

    if (!_hasSelection) {
      setState(() => _selectError = true);
      return;
    }
    if (!reasonOk || _overLimit) return;

    Navigator.of(context).pop((
      reason: _reason.text.trim(),
      items: [
        for (final e in _qty.entries)
          RefundItemSelection(orderItemId: e.key, quantity: e.value),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;

    return Padding(
      // الكيبورد
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: paddingAll(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.refund_sheet_title.tr(),
                style: AppTextStyles.text18Bold,
              ),
              16.verticalSpace,
              Text(
                LocaleKeys.refund_pick_items.tr(),
                style: AppTextStyles.text12Bold,
              ),
              8.verticalSpace,
              for (final item in _selectable)
                _ItemStepper(
                  item: item,
                  qty: _qty[item.id] ?? 0,
                  onChanged: (v) => _setQty(item, v),
                ),
              if (_hasSelection) ...[
                8.verticalSpace,
                Text(
                  LocaleKeys.refund_estimated.tr(args: ['$_estimate']),
                  style: AppTextStyles.text12Bold,
                ),
              ],
              if (_selectError)
                Padding(
                  padding: paddingSymmetric(0, 6),
                  child: Text(
                    LocaleKeys.refund_select_one.tr(),
                    style: AppTextStyles.text12Regular.copyWith(
                      color: errorColor,
                    ),
                  ),
                ),
              if (_hasSelection && _overLimit)
                Padding(
                  padding: paddingSymmetric(0, 6),
                  child: Text(
                    LocaleKeys.refund_estimate_exceeds.tr(
                      args: ['${widget.refundable}'],
                    ),
                    style: AppTextStyles.text12Regular.copyWith(
                      color: errorColor,
                    ),
                  ),
                ),
              12.verticalSpace,
              TextFormField(
                controller: _reason,
                maxLines: 4,
                maxLength: _maxReason,
                textInputAction: TextInputAction.newline,
                validator: _validateReason,
                decoration: InputDecoration(
                  labelText: LocaleKeys.refund_reason_label.tr(),
                  alignLabelWithHint: true,
                ),
              ),
              12.verticalSpace,
              AppButton(
                height: 44,
                label: LocaleKeys.refund_submit.tr(),
                onPressed: _submit,
              ),
              16.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemStepper extends StatelessWidget {
  final OrderDetailsItem item;
  final int qty;
  final ValueChanged<int> onChanged;

  const _ItemStepper({
    required this.item,
    required this.qty,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final title = item.size.isEmpty ? item.name : '${item.name} • ${item.size}';

    return Padding(
      padding: paddingSymmetric(0, 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.text12Bold,
                ),
                2.verticalSpace,
                Text(
                  '${item.unitPrice} L.E × ${item.refundableQuantity}',
                  style: AppTextStyles.text10Regular,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: qty > 0 ? () => onChanged(qty - 1) : null,
            icon: const Icon(Icons.remove_circle_outline),
          ),
          SizedBox(
            width: 24.w,
            child: Text(
              '$qty',
              textAlign: TextAlign.center,
              style: AppTextStyles.text14Bold,
            ),
          ),
          IconButton(
            onPressed: qty < item.refundableQuantity
                ? () => onChanged(qty + 1)
                : null,
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
    );
  }
}