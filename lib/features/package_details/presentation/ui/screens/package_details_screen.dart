import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/widgets/custom_back_icon.dart';
import 'package:konoz/features/package_details/data/model/package_details_model.dart';
import 'package:konoz/features/package_details/presentation/controller/package_details_cubit.dart';
import 'package:konoz/features/package_details/presentation/ui/widgets/package_bottom_bar.dart';
import 'package:konoz/features/package_details/presentation/ui/widgets/package_description_section.dart';
import 'package:konoz/features/package_details/presentation/ui/widgets/package_images_header.dart';
import 'package:konoz/features/package_details/presentation/ui/widgets/package_info_section.dart';
import 'package:konoz/features/package_details/presentation/ui/widgets/package_products_section.dart';
import 'package:konoz/generated/locale_keys.g.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PackageDetailsScreen extends StatefulWidget {
  final String packageId;
  const PackageDetailsScreen({super.key, required this.packageId});

  @override
  State<PackageDetailsScreen> createState() => _PackageDetailsScreenState();
}

class _PackageDetailsScreenState extends State<PackageDetailsScreen> {

  @override
  void initState() {
    super.initState();
    context.read<PackageDetailsCubit>().load(widget.packageId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PackageDetailsCubit, PackageDetailsState>(
      buildWhen: (p, c) => p.status != c.status || p.package != c.package,
      builder: (context, state) {
        if (state.isFailure && state.package == null) {
          return _ErrorView(
            message: state.failure?.message ?? '',
            onRetry: () => context.read<PackageDetailsCubit>().retry(),
          );
        }

        final loading = state.package == null;
        final pkg = state.package ?? PackageDetailsModel.empty();

        return Scaffold(
          body: SafeArea(
            top: false,
            child: Stack(
              children: [
                Skeletonizer(
                  enabled: loading,
                  child: SingleChildScrollView(
                    padding: paddingOnly(bottom: 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PackageImagesHeader(images: pkg.images),
                        PackageInfoSection(package: pkg),
                        PackageProductsSection(products: pkg.products),
                        PackageDescriptionSection(package: pkg),
                      ],
                    ),
                  ),
                ),
                PackageBottomBar(package: pkg, enabled: !loading),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(message, textAlign: TextAlign.center),
                    12.verticalSpace,
                    OutlinedButton(
                      onPressed: onRetry,
                      child: Text(LocaleKeys.general_retry.tr()),
                    ),
                  ],
                ),
              ),
            ),
            PositionedDirectional(
              start: 16.w,
              top: 16.h,
              child: CustomBackIcon(),
            ),
          ],
        ),
      ),
    );
  }
}
