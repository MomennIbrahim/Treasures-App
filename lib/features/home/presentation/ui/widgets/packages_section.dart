import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_shimmer.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/home/presentation/controllers/packages_cubit.dart';
import 'package:konoz/features/home/presentation/ui/widgets/packages_list_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PackagesSection extends StatefulWidget {
  const PackagesSection({super.key});

  @override
  State<PackagesSection> createState() => _PackagesSectionState();
}

class _PackagesSectionState extends State<PackagesSection> {
  @override
  void initState() {
    super.initState();
    context.read<PackagesCubit>().getPackages();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocConsumer<PackagesCubit, PackagesState>(
        listener: (context, state) {
          if (state.isFailure && state.failure != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.failure!.getAllError())),
            );
          }
        },
        builder: (context, state) {
          final bool isLoading = state.isLoading || state.isInitial;

          final packages = state.packages?.packages ?? [];

          if (packages.isEmpty && !isLoading) {
            return const SizedBox.shrink();
          }

          return Skeletonizer(
            enabled: isLoading,
            effect: AppShimmer.effect,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: paddingOnly(left: 16, right: 16, top: 20),
                  child: Text("Packages", style: AppTextStyles.text14Bold),
                ),
                10.verticalSpace,
                PackagesListView(packages: packages, isLoading: isLoading),
              ],
            ),
          );
        },
      ),
    );
  }
}
