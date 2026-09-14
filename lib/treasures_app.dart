import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/router/app_router.dart';
import 'package:konoz/core/theme/app_theme_data.dart';
import 'package:konoz/features/layout/presentation/controller/layout_cubit.dart';

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
        child: BlocProvider(
          create: (context) => LayoutCubit(),
          child: BlocBuilder<LayoutCubit, LayoutState>(
            builder: (context, state) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                routerConfig: AppRouter.router,

                locale: context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,

                title: 'Treasures',

                theme: AppThemeData.light,
                darkTheme: AppThemeData.dark,
                themeMode: state.themeMode,
              );
            },
          ),
        ),
      ),
    );
  }
}
