import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/checkout/presentation/controllers/checkout/checkout_cubit.dart';
import 'package:konoz/features/checkout/presentation/ui/widgets/address_card.dart';
import 'package:konoz/features/profile/data/model/profile_model.dart';
import 'package:konoz/features/profile/presentation/controllers/profile/profile_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// المختار ← الافتراضي ← أول عنوان ← null
AddressModel? resolveCheckoutAddress(
  List<AddressModel> addresses,
  int? selectedId,
) {
  if (addresses.isEmpty) return null;
  if (selectedId != null) {
    for (final a in addresses) {
      if (int.tryParse(a.id.toString()) == selectedId) return a;
    }
  }
  for (final a in addresses) {
    if (a.isDefault) return a;
  }
  return addresses.first;
}

class CheckoutAddressSection extends StatelessWidget {
  const CheckoutAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
        if (profileState.isLoading) {
          return const Skeletonizer(
            child: AddressCard(
              title: 'Home',
              fullAddress: 'Alexandria, Egypt, street name 12',
              name: 'Customer name',
              phone: '+20 100 000 0000',
            ),
          );
        }

        final profile = profileState.profile;
        final addresses = profile?.addresses ?? const <AddressModel>[];

        return BlocSelector<CheckoutCubit, CheckoutState, int?>(
          selector: (s) => s.selectedAddressId,
          builder: (context, selectedId) {
            final address = resolveCheckoutAddress(addresses, selectedId);

            if (address == null) return const _NoAddress();

            return AddressCard(
              title: address.title,
              fullAddress: address.fullAddress,
              name: profile?.name ?? '',
              phone: profile?.phone ?? '',
              onChange: () => _pickAddress(context, addresses, address),
            );
          },
        );
      },
    );
  }

  void _pickAddress(
    BuildContext context,
    List<AddressModel> addresses,
    AddressModel current,
  ) {
    final cubit = context.read<CheckoutCubit>();
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: paddingAll(16),
          children: [
            for (final a in addresses)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(a.title, style: AppTextStyles.text14Bold),
                subtitle: Text(
                  a.fullAddress,
                  style: AppTextStyles.text12Regular,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: a.id.toString() == current.id.toString()
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : null,
                onTap: () {
                  cubit.selectAddress(int.parse(a.id.toString()));
                  Navigator.of(sheetContext).pop();
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _NoAddress extends StatelessWidget {
  const _NoAddress();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.br8,
      // عدّل الراوت لو شاشة اختيار العنوان عندك اسمها مختلف
      onTap: () => context.push(Routes.addressPicker),
      child: Container(
        width: double.infinity,
        padding: paddingAll(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
          borderRadius: AppRadius.br8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_location_alt_outlined,
              color: AppColors.primary,
            ),
            8.horizontalSpace,
            Text(
              LocaleKeys.personal_data_add_address.tr(),
              style: AppTextStyles.text14Bold.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
