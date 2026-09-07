import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/features/about_us/about_us_screen.dart';
import 'package:konoz/features/collections/collectoins_screen.dart';
 import 'package:konoz/features/contact_us/contact_screen.dart';
import 'package:konoz/features/home/presentation/ui/screens/home_screen.dart';
import 'package:konoz/features/layout/presentation/ui/screens/layout_screen.dart';

import 'routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return LayoutScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.collections,
                builder: (context, state) => const CollectionScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.aboutUs,
                builder: (context, state) => const AboutUsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.contactUs,
                builder: (context, state) => const ContactScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}