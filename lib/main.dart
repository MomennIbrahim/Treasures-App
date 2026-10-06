import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/di/dependency_injection.dart';
import 'package:konoz/core/helper/bloc_observe.dart';
import 'package:konoz/core/local_storage/app_cache.dart';
import 'package:konoz/core/local_storage/secure_cache.dart';
import 'package:konoz/treasures_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();

  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await Supabase.initialize(
    url: 'https://qudwqplkxtxnyzmlidga.supabase.co',
    publishableKey: 'sb_publishable_nkIJXORFO2uNnridR-95Rg_N3PyvevM',
  );
  await AppCache.cacheInit();
  SecureCache.secureCacheInit();

  await setupGetIt();
  Bloc.observer = MyBlocObserver();

  // Remove Landscape Mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: const TreasuresApp(),
    ),
  );
}
