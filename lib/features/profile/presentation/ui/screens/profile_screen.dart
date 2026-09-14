import 'package:flutter/material.dart';
import 'package:konoz/core/helper/app_padding.dart';
import 'package:konoz/features/profile/presentation/ui/widgets/profile_tab_widget.dart';
import 'package:konoz/features/profile/presentation/ui/widgets/user_info_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: paddingAll(16),
        child: CustomScrollView(
          slivers: [
            UserInfoSection(),
            ProfileTabWidget(),
            // 24.0.sliverHeight,
            // if (Constance.userToken != null) ...[
            //   AccountDashboardTilesWidget(),
            //   24.0.sliverHeight,
            //   MyAccountWidget(),
            //   24.0.sliverHeight,
            // ],
            // SettingsWidget(),
          ],
        ),
      ),
    );
  }
}
