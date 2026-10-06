import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_shimmer.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/features/profile/data/model/profile_model.dart';
import 'package:konoz/features/profile/presentation/controllers/profile_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserInfoSection extends StatelessWidget {
  const UserInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverToBoxAdapter(
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.isFailure) {
            AppToast.show(
              context,
              message: state.failure?.getAllError() ?? '',
              type: AppToastType.error,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.isLoading || state.isInitial;
          final profile = isLoading ? ProfileModel.empty() : state.profile!;

          final displayName = profile.name.isNotEmpty ? profile.name : "User";

          return Skeletonizer(
            enabled: isLoading,
            effect: AppShimmer.effect(context),
            child: Container(
              padding: paddingSymmetric(16, 12),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.05),
                borderRadius: AppRadius.br12,
              ),
              child: Row(
                children: [
                  Skeleton.replace(
                    width: 50.w,
                    height: 50.w,
                    child: AppImage.cachedNetwork(
                      profile.avatarUrl,
                      height: 50,
                      width: 50,
                      fit: BoxFit.contain,
                      borderRadius: AppRadius.br8,
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, $displayName',
                          style: AppTextStyles.text16Bold,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (isLoading || profile.email.isNotEmpty)
                          Text(
                            profile.email,
                            style: AppTextStyles.text12Bold,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
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
