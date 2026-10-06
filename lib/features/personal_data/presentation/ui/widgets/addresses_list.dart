import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/widgets/show_blurred_confirmation_dialog.dart';
import 'package:konoz/features/personal_data/presentation/ui/widgets/addres_item_widget.dart';
import 'package:konoz/features/profile/data/model/profile_model.dart';
import 'package:konoz/features/profile/presentation/controllers/profile/profile_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class AddressesList extends StatelessWidget {
  final List<AddressModel> addresses;
  final bool isLoading;

  const AddressesList({
    super.key,
    required this.addresses,
    required this.isLoading,
  });

  void _confirmDelete(BuildContext context, AddressModel address) {
    final cubit = context.read<ProfileCubit>();
    showBlurredConfirmationDialog(
      context: context,
      title: LocaleKeys.personal_data_delete_title,
      message: LocaleKeys.personal_data_delete_message,
      confirmText: LocaleKeys.personal_data_delete_confirm.tr(),
      confirmColor: AppColors.error700,
      onConfirm: () => cubit.deleteAddress(address.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: addresses.length,
      separatorBuilder: (context, index) => 5.verticalSpace,
      itemBuilder: (context, index) {
        final address = addresses[index];
        return AddresItemWidget(
          address: address,
          onDelete: isLoading ? null : () => _confirmDelete(context, address),
          onSetDefault: isLoading
              ? null
              : () =>
                    context.read<ProfileCubit>().setDefaultAddress(address.id),
        );
      },
    );
  }
}
