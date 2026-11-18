import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/core/widgets/custom_back_icon.dart';
import 'package:konoz/features/settings/presentation/ui/widgets/change_app_theme.dart';
import 'package:konoz/features/settings/presentation/ui/widgets/change_language_dialog.dart';
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
              ChangeAppTheme(),
              16.verticalSpace,
              SettingsTileWidget(
                icon: HugeIcons.strokeRoundedTranslate,
                title: LocaleKeys.settings_change_language,
                onTap: () => showChangeLanguageDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}