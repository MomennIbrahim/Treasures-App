import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/profile/data/model/profile_model.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class AddresItemWidget extends StatelessWidget {
  final AddressModel address;
  final VoidCallback? onDelete;
  final VoidCallback? onSetDefault;

  const AddresItemWidget({
    super.key,
    required this.address,
    this.onDelete,
    this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: address.isDefault ? null : onSetDefault,
      child: Container(
        padding: paddingSymmetric(12, 8),
        decoration: BoxDecoration(
          color: colorScheme.onSurface.withValues(alpha: 0.05),
          borderRadius: AppRadius.br12,
          border: Border.all(
            color: address.isDefault ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on_outlined, color: colorScheme.primary),
            10.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          address.title,
                          style: AppTextStyles.text12Bold,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (address.isDefault) ...[
                        6.horizontalSpace,
                        Container(
                          padding: paddingSymmetric(6, 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: AppRadius.br8,
                          ),
                          child: Text(
                            LocaleKeys.personal_data_default.tr(),
                            style: AppTextStyles.text10Bold.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (address.fullAddress.isNotEmpty)
                    Text(
                      address.fullAddress,
                      style: AppTextStyles.text12Regular,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (onDelete != null)
              IconButton(
                onPressed: onDelete,
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedDelete02,
                  size: 16.sp,
                  color: AppColors.error700,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
