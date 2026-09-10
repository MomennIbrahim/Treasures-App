import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/widgets/app_search_bar.dart';
import 'package:konoz/features/layout/presentation/ui/widgets/app_bottom_nav_bar.dart';

class LayoutScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const LayoutScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;

    final isOrdersScreen = currentPath.contains(Routes.orders);
    final isProductDetailsScreen = currentPath.contains(Routes.productDetails);
    final isProfileScreen = currentPath == Routes.profile;
    final isPersonalDataScreen = currentPath.contains(Routes.personalData);
    final isSettingsScreen = currentPath.contains(Routes.settings);
    final isSearchScreen = currentPath.contains(Routes.search);

    final hideSearchBar =
        isOrdersScreen ||
        isSettingsScreen ||
        isSearchScreen ||
        isProfileScreen ||
        isProductDetailsScreen ||
        isPersonalDataScreen;

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: hideSearchBar
            ? null
            : AppSearchBar(
                showBackIcon: currentPath == Routes.collectionProducts,
              ),
        extendBody: true,
        body: navigationShell,
        bottomNavigationBar: AppBottomNavBar(navigationShell: navigationShell),
      ),
    );
  }
}
