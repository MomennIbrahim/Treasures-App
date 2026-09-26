import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/di/dependency_injection.dart';
import 'package:konoz/features/auth/presentation/ui/screens/auth_screen.dart';
import 'package:konoz/features/auth/presentation/ui/screens/otp_screen.dart';
import 'package:konoz/features/cart/ui/screens/cart_screen.dart';
import 'package:konoz/features/checkout/presentation/ui/screens/checkout_screen.dart';
import 'package:konoz/features/collection_products/presentation/controllers/collection_products/collection_products_cubit.dart';
import 'package:konoz/features/collection_products/presentation/ui/screens/collection_products_screen.dart';
import 'package:konoz/features/collections/presentation/controllers/collections/collections_cubit.dart';
import 'package:konoz/features/collections/presentation/ui/screens/collectoins_screen.dart';
import 'package:konoz/features/community/presentation/ui/community_screen.dart';
import 'package:konoz/features/faq/presentation/ui/faq_screen.dart';
import 'package:konoz/features/favorites/presentation/ui/screens/favorite_screen.dart';
import 'package:konoz/features/home/presentation/controllers/banners_cubit/banners_cubit.dart';
import 'package:konoz/features/home/presentation/controllers/best_selling/best_selling_cubit.dart';
import 'package:konoz/features/home/presentation/controllers/currently_trending/currently_trending_cubit.dart';
import 'package:konoz/features/home/presentation/controllers/packages_cubit.dart';
import 'package:konoz/features/home/presentation/ui/screens/home_screen.dart';
import 'package:konoz/features/layout/presentation/ui/screens/layout_screen.dart';
import 'package:konoz/features/orders/presentation/ui/screens/orders_screen.dart';
import 'package:konoz/features/personal_data/presentation/controllers/addresses/addresses_cubit.dart';
import 'package:konoz/features/personal_data/presentation/ui/screens/personal_data_screen.dart';
import 'package:konoz/features/personal_data/presentation/ui/widgets/address_picker_screen.dart';
import 'package:konoz/features/product_details/presentation/controllers/product_details/product_details_cubit.dart';
import 'package:konoz/features/product_details/presentation/ui/screens/product_details_screen.dart';
import 'package:konoz/features/profile/presentation/ui/screens/profile_screen.dart';
import 'package:konoz/features/search/presentation/ui/screens/search_products_screen.dart';
import 'package:konoz/features/search/presentation/ui/screens/search_screen.dart';
import 'package:konoz/features/settings/presentation/ui/screens/settings_screen.dart';

import 'routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.auth,
    routes: [
      // Auth Routes
      GoRoute(
        path: Routes.auth,
        pageBuilder: (context, state) {
          return AppPageTransition.fade(state: state, child: AuthScreen());
        },
      ),
      GoRoute(
        path: Routes.otp,
        pageBuilder: (context, state) {
          return AppPageTransition.fade(state: state, child: OtpScreen());
        },
      ),

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

                routes: [
                  GoRoute(
                    path: Routes.productDetails,
                    pageBuilder: (context, state) {
                      return AppPageTransition.fade(
                        state: state,
                        child: BlocProvider(
                          create: (context) => getIt.get<ProductDetailsCubit>(),
                          child: ProductDetailsScreen(),
                        ),
                      );
                    },
                  ),
                  GoRoute(
                    path: Routes.search,
                    pageBuilder: (context, state) {
                      return AppPageTransition.fade(
                        state: state,
                        child: SearchScreen(),
                      );
                    },
                    routes: [
                      // GoRoute(
                      //   path: Routes.searchResult,
                      //   pageBuilder: (context, state) {
                      //     return AppPageTransition.fade(
                      //       state: state,
                      //       child: BlocProvider(
                      //         create: (context) =>
                      //             getIt.get<CollectionProductsCubit>()
                      //               ..getCollectionProducts(collectionId: 1),
                      //         child: SearchProductsScreen(),
                      //       ),
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ],
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
              GoRoute(
                path: Routes.collectionProducts,
                pageBuilder: (context, state) {
                  final collectionId = state.extra as String;
                  return AppPageTransition.fade(
                    state: state,
                    child: BlocProvider(
                      create: (context) => getIt.get<CollectionProductsCubit>(),
                      child: CollectionProductsScreen(collectionId: collectionId,),
                    ),
                  );
                },
                routes: [
                  GoRoute(
                    path: Routes.productDetails,
                    pageBuilder: (context, state) {
                      return AppPageTransition.fade(
                        state: state,
                        child: BlocProvider(
                          create: (context) => getIt.get<ProductDetailsCubit>(),
                          child: ProductDetailsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.cart,
                builder: (context, state) => const CartScreen(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profile,
                pageBuilder: (context, state) => AppPageTransition.fade(
                  state: state,
                  child: ProfileScreen(),
                ),
                routes: [
                  GoRoute(
                    path: Routes.orders,
                    pageBuilder: (context, state) {
                      return AppPageTransition.fade(
                        state: state,
                        child: OrdersScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    path: Routes.personalData,
                    pageBuilder: (context, state) {
                      return AppPageTransition.fade(
                        state: state,
                        child: PersonalDataScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    path: Routes.favorites,
                    pageBuilder: (context, state) {
                      return AppPageTransition.fade(
                        state: state,
                        child: FavoriteScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    path: Routes.settings,
                    pageBuilder: (context, state) {
                      return AppPageTransition.fade(
                        state: state,
                        child: SettingsScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    path: Routes.community,
                    pageBuilder: (context, state) {
                      return AppPageTransition.fade(
                        state: state,
                        child: CommunityScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    path: Routes.faq,
                    pageBuilder: (context, state) {
                      return AppPageTransition.fade(
                        state: state,
                        child: FaqScreen(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: Routes.checkout,
        pageBuilder: (context, state) {
          return AppPageTransition.fade(state: state, child: CheckoutScreen());
        },
      ),

      GoRoute(
        path: Routes.addressPicker,
        pageBuilder: (context, state) {
          return AppPageTransition.fade(
            state: state,
            child: BlocProvider(
              create: (context) => getIt.get<AddressesCubit>(),
              child: AddressPickerScreen(),
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
      transitionDuration: const Duration(milliseconds: 100),
      reverseTransitionDuration: const Duration(milliseconds: 100),
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
