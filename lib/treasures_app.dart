import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/constance/app_keys.dart';
import 'package:konoz/core/di/dependency_injection.dart';
import 'package:konoz/core/theme/app_theme_data.dart';
import 'package:konoz/features/cart/presentation/controller/cart/cart_cubit.dart';
import 'package:konoz/features/layout/presentation/controller/layout_cubit.dart';
import 'package:konoz/features/profile/presentation/controllers/profile/profile_cubit.dart';
import 'package:konoz/features/profile/presentation/ui/widgets/app_router.dart';

class TreasuresApp extends StatefulWidget {
  const TreasuresApp({super.key});

  @override
  State<TreasuresApp> createState() => _TreasuresAppState();
}

class _TreasuresAppState extends State<TreasuresApp> {
  bool _firstFrameScheduled = false;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => LayoutCubit()),
            BlocProvider.value(value: getIt<ProfileCubit>()..getProfile()),
            BlocProvider.value(value: getIt<CartCubit>()),
          ],
          child: BlocBuilder<LayoutCubit, LayoutState>(
            builder: (context, state) {
              AppConstance.currentLanguage = context.locale.languageCode;

              return MaterialApp.router(
                builder: (context, child) {
                  if (!_firstFrameScheduled) {
                    _firstFrameScheduled = true;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      WidgetsBinding.instance.allowFirstFrame();
                    });
                  }
                  return child!;
                },
                debugShowCheckedModeBanner: false,
                routerConfig: AppRouter.router,
                locale: context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
                title: 'Knooz',
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
