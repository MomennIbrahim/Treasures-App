import 'package:konoz/core/router/routes.dart';

enum AppNavItem {
  home,
  collection,
  cart,
  profile,
}

extension AppNavItemRoute on AppNavItem {
  String get routeName {
    switch (this) {
      case AppNavItem.home:
        return Routes.home;
      case AppNavItem.collection:
        return Routes.collections;
      case AppNavItem.cart:
        return Routes.cart;
      case AppNavItem.profile:
        return Routes.profile;
    }
  }
}