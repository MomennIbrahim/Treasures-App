import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/custom_back_icon.dart';
import 'package:konoz/features/order_details/presentation/ui/widgets/order_cancel_button.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class OrderDetailsBar extends StatelessWidget {
  final bool canCancel;
  final bool loading;
  const OrderDetailsBar({
    super.key,
    required this.canCancel,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          CustomBackIcon(),
          12.horizontalSpace,
          Expanded(
            flex: 2,
            child: Text(
              LocaleKeys.order_details_order_details.tr(),
              style: AppTextStyles.text18Bold,
            ),
          ),
          if (!loading && canCancel) ...[
            24.verticalSpace,
            const OrderCancelButton(),
          ],
        ],
      ),
    );
  }
}
