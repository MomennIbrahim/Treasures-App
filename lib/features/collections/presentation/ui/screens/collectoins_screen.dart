import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_shimmer.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/features/collections/presentation/controllers/collections/collections_cubit.dart';
import 'package:konoz/features/collections/presentation/ui/widgets/collections_grid_view.dart';
import 'package:konoz/generated/locale_keys.g.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CollectionsCubit>().getCollections();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CollectionsCubit, CollectionsState>(
      listener: (context, state) {
        if (state.isFailure) {
          AppToast.show(
            context,
            message: "Something went wrong",
            type: AppToastType.error,
          );
        }
        if (state.isSuccess) {
          AppToast.show(
            context,
            message: "Collections loaded successfully",
            type: AppToastType.success,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.isLoading || state.isInitial;

        if (!isLoading && state.collections.isEmpty) {
          return SizedBox.shrink();
        }

        final collections = state.collections;

        return Skeletonizer(
          enabled: isLoading,
          effect: AppShimmer.effect,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: paddingHorizontal(16),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Text(
                        LocaleKeys.collections_featured_collections.tr(),
                        style: AppTextStyles.text14Bold,
                        textAlign: TextAlign.center,
                      ),
                      4.verticalSpace,
                      Text(
                        LocaleKeys.collections_featured_collections_description
                            .tr(),
                        style: AppTextStyles.text10Regular,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              CollectionsGridView(
                collections: collections,
                isLoading: isLoading,
              ),

              SliverToBoxAdapter(
                child: SafeArea(top: false, child: SizedBox.shrink()),
              ),
            ],
          ),
        );
      },
    );
  }
}
