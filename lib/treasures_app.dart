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
    return ScreenUtilInit(
      designSize: const Size(360, 800),
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
