import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_shimmer.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_slider.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/features/home/data/demo/demo_banners_data.dart';
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
            }
            AppToast.show(
              context,
              message: "Banners loaded successfully 🎉",
              type: AppToastType.success,
            );
          },
          builder: (context, state) {
            final bool isLoading = state.isLoading || state.isInitial;

            final bannersList = isLoading
                ? DemoBannersData.banners.bannersData ?? []
                : state.banners?.bannersData ?? [];

            if (bannersList.isEmpty && !isLoading) {
              return SizedBox.shrink();
            }

            return Skeletonizer(
              effect: AppShimmer.effect,
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
                    items: bannersList
                        .map(
                          (e) => ImageBannerItem(
                            imagePath: e.image,
                            title: e.title,
                            subtitle: e.subtitle,
                            buttonLabel: e.buttonLabel,
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
