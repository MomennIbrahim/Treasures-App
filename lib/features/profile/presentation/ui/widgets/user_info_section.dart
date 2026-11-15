import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/di/dependency_injection.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_shimmer.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/features/auth/presentation/ui/widgets/auth_sheet.dart';
import 'package:konoz/features/profile/data/model/profile_model.dart';
import 'package:konoz/features/profile/presentation/controllers/profile/profile_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserInfoSection extends StatelessWidget {
  const UserInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverToBoxAdapter(
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listenWhen: (p, c) => p.status != c.status && c.isFailure,
        listener: (context, state) {
          AppToast.show(
            context,
            message: state.failure?.getAllError().toString() ?? '',
            type: AppToastType.error,
          );
        },
        builder: (context, state) {
          if (state.isGuest) return const _GuestCard();

          final isLoading = state.isLoading || state.isInitial;
          final profile = (isLoading || state.profile == null)
              ? ProfileModel.empty()
              : state.profile!;

          final displayName = profile.name.isNotEmpty ? profile.name : 'User';
          final subtitle = profile.email.isNotEmpty
              ? profile.email
              : profile.phone;

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
                    child: profile.avatarUrl.isNotEmpty
                        ? AppImage.cachedNetwork(
                            profile.avatarUrl,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                            borderRadius: AppRadius.br8,
                          )
                        : CircleAvatar(
                            radius: 25.r,
                            backgroundColor: colorScheme.primary,
                            child: Text(
                              displayName[0].toUpperCase(),
                              style: AppTextStyles.text16Bold.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${LocaleKeys.me_hi.tr()}, $displayName',
                          style: AppTextStyles.text16Bold,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitle.isNotEmpty)
                          Text(
                            subtitle,
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

class _GuestCard extends StatelessWidget {
  const _GuestCard();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: AppRadius.br12,
      onTap: () async {
        final user = await showRegisterSheet(context);
        if (user != null) getIt<ProfileCubit>().getProfile();
      },
      child: Container(
        padding: paddingSymmetric(16, 16),
        decoration: BoxDecoration(
          color: cs.onSurface.withValues(alpha: 0.05),
          borderRadius: AppRadius.br12,
        ),
        child: Row(
          children: [
            const Icon(Icons.person_outline),
            10.horizontalSpace,
            Expanded(
              child: Text(
                'Login or create an account',
                style: AppTextStyles.text14Regular,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
      ),
    );
  }
}
