import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_shimmer.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/features/home/presentation/controllers/currently_trending/currently_trending_cubit.dart';
import 'package:konoz/features/home/presentation/ui/widgets/currently_trending_listview_horizontal.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CurrenttlyTrendingSection extends StatefulWidget {
  const CurrenttlyTrendingSection({super.key});

  @override
  State<CurrenttlyTrendingSection> createState() =>
      _CurrenttlyTrendingSectionState();
}

class _CurrenttlyTrendingSectionState extends State<CurrenttlyTrendingSection> {
  @override
  void initState() {
    super.initState();
    context.read<CurrentlyTrendingCubit>().getCurrentlyTrending();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocConsumer<CurrentlyTrendingCubit, CurrentlyTrendingState>(
        listener: (context, state) {
          if (state.isFailure && state.failure != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.failure!.getAllError())),
            );
          }
        },
        builder: (context, state) {
          final bool isLoading = state.isLoading || state.isInitial;

          final products = state.currentlyTrending?.products ?? [];

          if (products.isEmpty && !isLoading) {
            return const SizedBox.shrink();
          }

          return Skeletonizer(
            enabled: isLoading,
            effect: AppShimmer.effect,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: paddingOnly(left: 16, right: 16, top: 16, bottom: 4),
                  child: Text(
                    "Currently Trending",
                    style: AppTextStyles.text14Bold,
                  ),
                ),
                10.verticalSpace,
                CurrentlyTrendingListviewHorizontal(
                  products: products,
                  isLoading: isLoading,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
