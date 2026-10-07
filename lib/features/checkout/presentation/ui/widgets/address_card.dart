import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
    required this.title,
    required this.fullAddress,
    required this.name,
    required this.phone,
    this.onChange,
  });

  final String title;
  final String fullAddress;
  final String name;
  final String phone;
  final VoidCallback? onChange;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: paddingAll(16),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.onSurfaceVariant.withAlpha(20)),
        borderRadius: AppRadius.br8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: paddingAll(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: AppRadius.br8,
            ),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedLocation01,
              color: AppColors.primary,
              size: 22.sp,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(title, style: AppTextStyles.text14Bold),
                    ),
                    if (onChange != null)
                      InkWell(
                        onTap: onChange,
                        child: Text(
                          LocaleKeys.checkout_change_address.tr(),
                          style: AppTextStyles.text12Bold.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
                6.verticalSpace,
                if (name.isNotEmpty)
                  Text(name, style: AppTextStyles.text12Regular),
                4.verticalSpace,
                Text(fullAddress, style: AppTextStyles.text12Regular),
                if (phone.isNotEmpty) ...[
                  4.verticalSpace,
                  Text(phone, style: AppTextStyles.text12Regular),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
