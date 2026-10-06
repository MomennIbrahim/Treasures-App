import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/theme/app_shimmer.dart';
import 'package:konoz/core/widgets/app_toast.dart';
import 'package:konoz/core/widgets/custom_back_icon.dart';
import 'package:konoz/core/widgets/show_loading_dialog.dart';
import 'package:konoz/features/personal_data/presentation/ui/widgets/addresses_section.dart';
import 'package:konoz/features/personal_data/presentation/ui/widgets/personal_information_form.dart';
import 'package:konoz/features/profile/data/model/profile_model.dart';
import 'package:konoz/features/profile/presentation/controllers/profile/profile_cubit.dart';
import 'package:konoz/generated/locale_keys.g.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PersonalDataScreen extends StatefulWidget {
  const PersonalDataScreen({super.key});

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<ProfileCubit>();
    if (cubit.state.profile == null) cubit.getProfile();
  }

  String _successMessage(ProfileAction? action) {
    switch (action) {
      case ProfileAction.addAddress:
        return LocaleKeys.personal_data_address_added.tr();
      case ProfileAction.deleteAddress:
        return LocaleKeys.personal_data_address_deleted.tr();
      case ProfileAction.setDefaultAddress:
        return LocaleKeys.personal_data_default_updated.tr();
      default:
        return LocaleKeys.personal_data_profile_updated.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: BlocListener<ProfileCubit, ProfileState>(
          listenWhen: (p, c) => p.actionStatus != c.actionStatus,
          listener: (context, state) {
            if (state.actionStatus == ProfileActionStatus.loading) {
              showLoadingDialog(context);
              return;
            }
            hideLoadingDialog(context);

            if (state.actionStatus == ProfileActionStatus.success) {
              AppToast.show(
                context,
                message: _successMessage(state.action),
                type: AppToastType.success,
              );
            } else if (state.actionStatus == ProfileActionStatus.failure) {
              AppToast.show(
                context,
                message: state.actionFailure?.getAllError() ?? '',
                type: AppToastType.error,
              );
            }
          },
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              // فشل التحميل: رسالة + إعادة محاولة (من غير داتا وهمية)
              if (state.isFailure && state.profile == null) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.failure?.getAllError() ?? ''),
                      TextButton(
                        onPressed: () =>
                            context.read<ProfileCubit>().getProfile(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final isLoading = state.profile == null;
              final profile = state.profile ?? ProfileModel.empty();

              return Skeletonizer(
                enabled: isLoading,
                effect: AppShimmer.effect(context),
                child: SingleChildScrollView(
                  padding: paddingHorizontal(16),
                  child: Column(
                    children: [
                      const Align(
                        alignment: AlignmentDirectional.topStart,
                        child: CustomBackIcon(),
                      ),
                      Padding(
                        padding: paddingVertical(20),
                        child: Stack(
                          children: [
                            Skeleton.replace(
                              width: 110.w,
                              height: 110.w,
                              child: Container(
                                width: 110.w,
                                height: 110.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  border: Border.all(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                  image: profile.avatarUrl.isNotEmpty
                                      ? DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            profile.avatarUrl,
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: profile.avatarUrl.isEmpty
                                    ? Icon(
                                        Icons.person,
                                        size: 48.sp,
                                        color: colorScheme.primary,
                                      )
                                    : null,
                              ),
                            ),
                            Positioned(
                              bottom: 5.h,
                              right: 5.w,
                              child: InkWell(
                                onTap: () {}, // رفع الصورة (خطوة لاحقة)
                                child: CircleAvatar(
                                  radius: 14.r,
                                  backgroundColor: AppColors.primary,
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: AppColors.white,
                                    size: 16.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      PersonalInformationForm(
                        profile: profile,
                        isLoading: isLoading,
                      ),
                      16.verticalSpace,
                      AddressesSection(
                        addresses: profile.addresses,
                        isLoading: isLoading,
                      ),
                      32.verticalSpace,
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
