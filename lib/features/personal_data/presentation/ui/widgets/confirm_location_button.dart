import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/core/widgets/app_text_form_field.dart';
import 'package:konoz/features/personal_data/presentation/controllers/addresses/addresses_cubit.dart';
import 'package:konoz/features/profile/presentation/controllers/profile/profile_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class ConfirmLocationButton extends StatelessWidget {
  const ConfirmLocationButton({super.key});

  Future<String?> _askTitle(BuildContext context) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(LocaleKeys.personal_data_address_title.tr()),
        titleTextStyle: AppTextStyles.text14Bold,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextFormField(
              controller: controller,
              hint: LocaleKeys.personal_data_address_title.tr(),
            ),
            16.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    height: 33,
                    onPressed: () {
                      final v = controller.text.trim();
                      if (v.isNotEmpty) Navigator.of(ctx).pop(v);
                    },
                    label: LocaleKeys.dialogs_confirm,
                    labelStyle: AppTextStyles.text12Bold,
                    borderRadius: AppRadius.br12,
                  ),
                ),
                8.horizontalSpace,
                Expanded(
                  child: AppButton(
                    height: 33,
                    onPressed: () => context.pop(),
                    label: LocaleKeys.dialogs_cancel,
                    variant: AppButtonVariant.outlined,
                    labelStyle: AppTextStyles.text12Regular,
                    borderRadius: AppRadius.br12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onConfirm(BuildContext context) async {
    final addressesState = context.read<AddressesCubit>().state;
    final position = addressesState.selectedPosition;
    final address = addressesState.resolvedAddress;
    if (position == null || address == null) return;

    final profileCubit = context.read<ProfileCubit>();
    final title = await _askTitle(context);
    if (title == null) return;

    await profileCubit.addAddress(
      title: title,
      fullAddress: address,
      lat: position.latitude,
      lng: position.longitude,
    );

    if (context.mounted && profileCubit.state.actionFailure == null) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom,
      left: 16.w,
      right: 16.w,
      child: BlocBuilder<AddressesCubit, AddressesState>(
        buildWhen: (p, c) =>
            p.resolvedAddress != c.resolvedAddress ||
            p.isPickingLocationLoading != c.isPickingLocationLoading,
        builder: (context, state) {
          final enabled =
              state.resolvedAddress != null && !state.isPickingLocationLoading;

          return GestureDetector(
            onTap: enabled ? () => _onConfirm(context) : null,
            child: Opacity(
              opacity: enabled ? 1 : 0.5,
              child: Container(
                width: double.infinity,
                padding: paddingAll(16),
                margin: paddingAll(16),
                decoration: BoxDecoration(
                  color: AppColors.success800,
                  borderRadius: AppRadius.br8,
                ),
                child: Center(
                  child: Text(
                    LocaleKeys.personal_data_confirm_location.tr(),
                    style: AppTextStyles.text12Bold.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
