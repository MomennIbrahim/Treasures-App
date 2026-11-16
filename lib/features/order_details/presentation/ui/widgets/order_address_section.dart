import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/order_details/data/model/order_details_model.dart';
import 'package:konoz/features/order_details/presentation/ui/widgets/order_details_card.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class OrderAddressSection extends StatelessWidget {
  final OrderAddressInfo address;
  const OrderAddressSection({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return OrderDetailsCard(
      title: LocaleKeys.checkout_delivery_address.tr(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HugeIcon(icon: HugeIcons.strokeRoundedLocation01, size: 18.sp),
          8.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (address.title.isNotEmpty)
                  Text(address.title, style: AppTextStyles.text12Bold),
                if (address.fullAddress.isNotEmpty)
                  Text(address.fullAddress, style: AppTextStyles.text12Regular),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
