import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/extension/navigation_service.dart';
import 'package:konoz/core/router/app_router.dart';
import 'package:konoz/core/router/routes.dart';
import 'package:konoz/core/theme/app_theme_data.dart';

class TreasuresApp extends StatelessWidget {
  const TreasuresApp({super.key});

  @override
  Widget build(BuildContext context) {
    Size getDesignSize(BuildContext context) {
      final width = MediaQuery.of(context).size.width;
      if (width >= 1024) {
        return const Size(1440, 1024); // desktop
      } else if (width >= 600) {
        return const Size(768, 1024); // tablet
      }
      return const Size(360, 800); // mobile
    }

    return ScreenUtilInit(
      designSize: getDesignSize(context),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.generateRoute,
          navigatorKey: NavigationService.navigatorKey,
          initialRoute: Routes.home,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          title: 'Treasures',
          theme: AppThemeData.light,
          darkTheme: AppThemeData.light,
          themeMode: ThemeMode.system,
        ),
      ),
    );
  }
}
