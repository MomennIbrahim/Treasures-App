import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/widgets/app_search_bar.dart';
import 'package:konoz/features/layout/presentation/ui/widgets/app_bottom_nav_bar.dart';

class LayoutScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const LayoutScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppSearchBar(),
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: AppBottomNavBar(navigationShell: navigationShell),
    );
  }
}
