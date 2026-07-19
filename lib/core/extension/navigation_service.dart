import 'package:flutter/material.dart';

abstract class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // static void navigateToLogin() {
  //   navigatorKey.currentState?.pushNamedAndRemoveUntil(
  //     Routes.login,
  //     (route) => false,
  //   );
  // }

  static void pushNamed(String route, {Object? arguments}) {
    navigatorKey.currentState?.pushNamed(route, arguments: arguments);
  }

  static void pushReplacementNamed(String route, {Object? arguments}) {
    navigatorKey.currentState?.pushReplacementNamed(
      route,
      arguments: arguments,
    );
  }

  static void pushNamedAndRemoveAll(String route, {Object? arguments}) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      route,
      (route) => false,
      arguments: arguments,
    );
  }

  static void pop() {
    navigatorKey.currentState?.pop();
  }
}
