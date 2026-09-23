import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/constance/images_paths.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/helper/launch_service.dart';
import 'package:konoz/core/theme/app_radius.dart';
import 'package:konoz/core/theme/app_text_style.dart';
import 'package:konoz/core/widgets/app_image.dart';
import 'package:konoz/core/widgets/custom_back_icon.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: AlignmentDirectional.topStart,
                child: CustomBackIcon(),
              ),
              Container(
                padding: paddingAll(16),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.people_alt_rounded,
                  size: 48,
                  color: colorScheme.onSurface,
                ),
              ),
              20.verticalSpace,
              Text(
                LocaleKeys.community_header_title.tr(),
                style: AppTextStyles.text18Bold,
                textAlign: TextAlign.center,
              ),
              8.verticalSpace,
              Text(
                LocaleKeys.community_header_subtitle.tr(),
                textAlign: TextAlign.center,
                style: AppTextStyles.text14Regular,
              ),

              40.verticalSpace,

              // Social Cards
              _SocialCard(
                icon: ImagesPaths.facebook,
                title: LocaleKeys.community_facebook_title.tr(),
                subtitle: LocaleKeys.community_facebook_subtitle.tr(),
                onTap: () => LaunchService.facebook(pageId: "100054649951700"),
              ),
              16.verticalSpace,
              _SocialCard(
                icon: ImagesPaths.insta,
                title: LocaleKeys.community_instagram_title.tr(),
                subtitle: LocaleKeys.community_instagram_subtitle.tr(),
                onTap: () => LaunchService.instagram('momen_memo2010'),
              ),
              16.verticalSpace,
              _SocialCard(
                icon: ImagesPaths.tiktok,
                title: LocaleKeys.community_tiktok_title.tr(),
                subtitle: LocaleKeys.community_tiktok_subtitle.tr(),
                onTap: () => LaunchService.tiktok('ducktokdaily'),
              ),
              16.verticalSpace,
              _SocialCard(
                icon: ImagesPaths.whatsapp,
                title: LocaleKeys.community_whatsapp_title.tr(),
                subtitle: LocaleKeys.community_whatsapp_subtitle.tr(),
                onTap: () => LaunchService.whatsapp('201211814372'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SocialCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.br16,
      onTap: onTap,
      child: Container(
        padding: paddingAll(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            AppImage.asset(icon, width: 32, height: 32),
            16.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.text12Bold),
                  2.verticalSpace,
                  Text(subtitle, style: AppTextStyles.text10Regular),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ],
        ),
      ),
    );
  }
}
