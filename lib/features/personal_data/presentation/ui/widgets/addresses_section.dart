import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/features/personal_data/presentation/ui/widgets/addresses_list.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class AddressesSection extends StatelessWidget {
  const AddressesSection({super.key});
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.checkout_delivery_address.tr(),
          style: AppTextStyles.text14Regular.copyWith(
            color: colorScheme.onSurface,
          ),
        ),

        8.verticalSpace,
        AddressesList(),
        8.verticalSpace,
        SafeArea(
          child: AppButton(
            label: "Add New Address",
            icon: Icon(Icons.add, color: AppColors.primary),
            onPressed: () {
              context.push(Routes.addressPicker);
            },
            variant: AppButtonVariant.outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: paddingSymmetric(16, 20),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: AppRadius.br12,
      ),
      child: Column(
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 28.sp,
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          8.verticalSpace,
          Text(
            'No addresses found',
            style: AppTextStyles.text12Regular.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
