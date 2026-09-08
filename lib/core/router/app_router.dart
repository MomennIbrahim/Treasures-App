import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/di/dependency_injection.dart';
import 'package:konoz/features/about_us/about_us_screen.dart';
import 'package:konoz/features/collections/presentation/controllers/collections/collections_cubit.dart';
import 'package:konoz/features/collections/presentation/ui/screens/collectoins_screen.dart';
import 'package:konoz/features/contact_us/contact_screen.dart';
import 'package:konoz/features/home/presentation/controllers/banners_cubit/banners_cubit.dart';
import 'package:konoz/features/home/presentation/controllers/best_selling/best_selling_cubit.dart';
import 'package:konoz/features/home/presentation/controllers/currently_trending/currently_trending_cubit.dart';
import 'package:konoz/features/home/presentation/controllers/packages_cubit.dart';
import 'package:konoz/features/home/presentation/ui/screens/home_screen.dart';
import 'package:konoz/features/layout/presentation/ui/screens/layout_screen.dart';
import 'package:konoz/features/product_details/presentation/controllers/product_details/product_details_cubit.dart';
import 'package:konoz/features/product_details/presentation/ui/screens/product_details_screen.dart';

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
                builder: (context, state) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: getIt.get<BannersCubit>()),
                    BlocProvider.value(value: getIt.get<BestSellingCubit>()),
                    BlocProvider.value(
                      value: getIt.get<CurrentlyTrendingCubit>(),
                    ),
                    BlocProvider.value(value: getIt.get<PackagesCubit>()),
                  ],
                  child: HomeScreen(),
                ),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.collections,
                builder: (context, state) => BlocProvider.value(
                  value: getIt.get<CollectionsCubit>(),
                  child: CollectionScreen(),
                ),
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

      GoRoute(
        path: Routes.productDetails,
        pageBuilder: (context, state) {
          return AppPageTransition.fade(
            state: state,
            child: BlocProvider.value(
              value: getIt.get<ProductDetailsCubit>(),
              child: ProductDetailsScreen(),
            ),
          );
        },
      ),
    ],
  );
}

class AppPageTransition {
  static CustomTransitionPage<T> fade<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      transitionDuration: const Duration(milliseconds: 50),
      reverseTransitionDuration: const Duration(milliseconds: 50),
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
