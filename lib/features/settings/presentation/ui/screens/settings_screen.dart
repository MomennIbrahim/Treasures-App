import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/theme/app_colors.dart';
import 'package:konoz/core/widgets/custom_back_icon.dart';
import 'package:konoz/features/settings/presentation/ui/widgets/change_language_dialog.dart';
import 'package:konoz/features/settings/presentation/ui/widgets/delete_account_dialog.dart';
import 'package:konoz/features/settings/presentation/ui/widgets/logout_dialog.dart';
import 'package:konoz/features/settings/presentation/ui/widgets/setting_tile_widget.dart';
import 'package:konoz/generated/locale_keys.g.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: paddingHorizontal(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomBackIcon(),
              16.verticalSpace,
              SettingsTileWidget(
                icon: HugeIcons.strokeRoundedTranslate,
                title: LocaleKeys.settings_change_language ,
                onTap: () => showChangeLanguageDialog(context),
              ),
              SettingsTileWidget(
                icon: HugeIcons.strokeRoundedLogout03,
                title: LocaleKeys.settings_logout,
                onTap: () => showLogoutDialog(context),
              ),

              SettingsTileWidget(
                icon: HugeIcons.strokeRoundedDelete02,
                title: LocaleKeys.settings_delete_account,
                titleColor: AppColors.error700,
                iconColor: AppColors.error700,
                onTap: () => showDeleteAccountDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
