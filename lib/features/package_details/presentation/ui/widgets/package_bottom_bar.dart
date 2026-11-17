import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_button.dart';
import 'package:konoz/core/widgets/app_loading.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/features/package_details/data/model/package_details_model.dart';
import 'package:konoz/features/package_details/presentation/controller/package_details_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';

/// السعر + زرار إضافة منتجات الباكدج للسلة.
class PackageBottomBar extends StatelessWidget {
  final PackageDetailsModel package;
  final bool enabled; // false وقت الـ skeleton

  const PackageBottomBar({
    super.key,
    required this.package,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: BlocConsumer<PackageDetailsCubit, PackageDetailsState>(
        listenWhen: (p, c) => p.addStatus != c.addStatus,
        listener: (context, state) {
          switch (state.addStatus) {
            case PackageAddStatus.success:
              AppToast.show(
                context,
                message: LocaleKeys.general_product_added_to_cart.tr(),
                type: AppToastType.success,
              );
            case PackageAddStatus.failure:
              AppToast.show(
                context,
                message:
                    state.addFailure?.message ??
                    LocaleKeys.errors_errors_unexpected.tr(),
                type: AppToastType.error,
              );
            case PackageAddStatus.idle:
            case PackageAddStatus.loading:
              break;
          }
        },
        buildWhen: (p, c) => p.addStatus != c.addStatus,
        builder: (context, state) {
          final canTap = enabled && !state.isAdding;

          return Container(
            padding: paddingAll(16),
            decoration: BoxDecoration(color: colorScheme.onSecondary),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Text(package.priceLabel, style: AppTextStyles.text16Bold),
                  16.horizontalSpace,
                  Expanded(
                    child: state.isAdding
                        ? AppLoading()
                        : AppButton(
                            height: 38,
                            onPressed: canTap
                                ? () => context
                                      .read<PackageDetailsCubit>()
                                      .addToCart()
                                : null,
                            label: LocaleKeys.general_add_to_cart.tr(),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
