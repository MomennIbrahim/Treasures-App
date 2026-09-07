import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/features/layout/presentation/ui/widgets/app_bottom_nav_bar.dart';

class LayoutScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const LayoutScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(bottom: false, child: navigationShell),
      bottomNavigationBar: AppBottomNavBar(navigationShell: navigationShell),
    );
  }
}
