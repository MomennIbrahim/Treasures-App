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
    final isOrdersScreen = currentPath == Routes.orders;
    final isSettingsScreen = currentPath == Routes.settings;
    final hideSearchBar = isOrdersScreen || isSettingsScreen;

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