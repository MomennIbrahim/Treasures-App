import 'package:flutter/material.dart';
import 'package:konoz/features/home/ui/home_screen.dart';
 

import 'routes.dart';

class AppRouter {
  static Route<Widget>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return _customMaterialPageRoute(page: HomeScreen());
      
      default:
        return null;
    }
  }

  static MaterialPageRoute<Widget> _customMaterialPageRoute({
    required Widget page,
  }) {
    return MaterialPageRoute(builder: (_) => page);
  }
}
