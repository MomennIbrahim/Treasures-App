import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/widgets/app_search_bar.dart';
import 'package:konoz/features/layout/presentation/ui/widgets/app_bottom_nav_bar.dart';
import 'package:konoz/features/spin/presentation/controllers/spin/spin_cubit.dart';

class LayoutScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const LayoutScreen({super.key, required this.navigationShell});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  @override
  void initState() {
    context.read<SpinCubit>().getWheel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;

    final isOrdersScreen = currentPath.contains(Routes.orders);
    final isProductDetailsScreen = currentPath.contains(Routes.productDetails);
    final isProfileScreen = currentPath == Routes.profile;
    final isPersonalDataScreen = currentPath.contains(Routes.personalData);
    final isSettingsScreen = currentPath.contains(Routes.settings);
    final isSearchScreen = currentPath.contains(Routes.search);
    final isCommunityScreen = currentPath.contains(Routes.community);
    final isFaqScreen = currentPath.contains(Routes.faq);
    final isPackageDetails = currentPath.contains(Routes.packageDetails);

    final hideSearchBar =
        isOrdersScreen ||
        isSettingsScreen ||
        isSearchScreen ||
        isProfileScreen ||
        isProductDetailsScreen ||
        isCommunityScreen ||
        isFaqScreen ||
        isPersonalDataScreen ||
        isPackageDetails;

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: SpinIconWidget(),
        appBar: hideSearchBar
            ? null
            : AppSearchBar(
                showBackIcon:
                    currentPath == Routes.collectionProducts ||
                    currentPath.contains(Routes.favorites) ||
                    currentPath.contains(Routes.offerProducts),
              ),
        extendBody: true,
        body: widget.navigationShell,
        bottomNavigationBar: AppBottomNavBar(
          navigationShell: widget.navigationShell,
        ),
      ),
    );
  }
}
