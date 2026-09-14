import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/show_blurred_confirmation_dialog.dart';

class AddresItemWidget extends StatelessWidget {
  const AddresItemWidget({super.key});

  Future<bool> _confirmDelete(BuildContext context) async {
    bool confirmed = false;

    await showBlurredConfirmationDialog(
      context: context,
      title: 'Delete Address',
      message: 'Are you sure you want to delete this address?',
      confirmText: 'Delete',
      onConfirm: () {
        confirmed = true;
      },
    );

    return confirmed;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    const bool isSelected = false;
    const String title = 'Home';
    const String address = 'Alexandria, Egypt';

    return Dismissible(
      key: const ValueKey('address-1'),
      direction: DismissDirection.horizontal,
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) {},

      background: _buildDeleteBackground(alignment: Alignment.centerLeft),

      secondaryBackground: _buildDeleteBackground(
        alignment: Alignment.centerRight,
      ),

      child: InkWell(
        onTap: () {},
        borderRadius: AppRadius.br12,
        child: Container(
          width: double.infinity,
          margin: paddingVertical(4),
          padding: paddingSymmetric(16, 14),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withValues(alpha: 0.10)
                : colorScheme.onSurface.withValues(alpha: 0.05),
            borderRadius: AppRadius.br12,
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outline.withValues(alpha: 0.2),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: paddingAll(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  size: 18.sp,
                  color: colorScheme.primary,
                ),
              ),

              10.horizontalSpace,

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.text12Bold,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.verticalSpace,
                    Text(
                      address,
                      style: AppTextStyles.text12Regular,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              8.horizontalSpace,

              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                size: 20.sp,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteBackground({required Alignment alignment}) {
    return Container(
      margin: paddingVertical(4),
      padding: paddingSymmetric(20, 0),
      alignment: alignment,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: AppRadius.br12,
      ),
      child: const Icon(Icons.delete_outline, color: Colors.white),
    );
  }
}
