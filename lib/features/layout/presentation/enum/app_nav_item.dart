import 'package:konoz/core/router/routes.dart';

enum AppNavItem {
  home,
  collection,
  about,
  contact,
}

extension AppNavItemRoute on AppNavItem {
  String get routeName {
    switch (this) {
      case AppNavItem.home:
        return Routes.home;
      case AppNavItem.collection:
        return Routes.collections;
      case AppNavItem.about:
        return Routes.aboutUs;
      case AppNavItem.contact:
        return Routes.contactUs;
    }
  }
}