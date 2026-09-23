import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_shimmer.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_slider.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/features/home/data/model/banners_model.dart';
import 'package:konoz/features/home/presentation/controllers/banners_cubit/banners_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeOffersSection extends StatefulWidget {
  const HomeOffersSection({super.key});

  @override
  State<HomeOffersSection> createState() => _HomeOffersSectionState();
}

class _HomeOffersSectionState extends State<HomeOffersSection> {
  @override
  void initState() {
    super.initState();
    context.read<BannersCubit>().getBanners();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: paddingHorizontal(16),
      sliver: SliverToBoxAdapter(
        child: BlocConsumer<BannersCubit, BannersState>(
          listener: (context, state) {
            if (state.isFailure) {
              AppToast.show(
                context,
                message: state.failure?.getAllError() ?? "Something went wrong",
                type: AppToastType.error,
              );
              log(state.failure?.getAllError() ?? "");
            }
          },
          builder: (context, state) {
            final bool isLoading = state.isLoading;

            final bannersList = state.banners?.bannersData ?? [];

            if (bannersList.isEmpty && !isLoading) {
              return const SizedBox.shrink();
            }

            final displayBanners = isLoading ? BannerData.emptyList() : bannersList;

            return Skeletonizer(
              effect: AppShimmer.effect(context),
              enabled: isLoading,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.home_exclusive_offers.tr(),
                    style: AppTextStyles.text14Bold,
                  ),
                  10.verticalSpace,
                  AppSlider(
                    items: displayBanners.map(
                          (e) => ImageBannerItem(
                            imagePath: e.image,
                            title: e.title,
                            subtitle: e.subtitle,
                            buttonLabel: "Explore Now",
                            onPressed: () {},
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
