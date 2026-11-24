import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konoz/core/di/dependency_injection.dart';
import 'package:konoz/core/helper/bloc_observe.dart';
import 'package:konoz/core/local_storage/app_cache.dart';
import 'package:konoz/core/local_storage/secure_cache.dart';
import 'package:konoz/core/local_storage/session_storage.dart';
import 'package:konoz/core/notifications/notification_service.dart';
import 'package:konoz/firebase_options.dart';
import 'package:konoz/treasures_app.dart';

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

  await EasyLocalization.ensureInitialized();

  await AppCache.cacheInit();
  SecureCache.secureCacheInit();
  await SessionStorage.load();

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
  unawaited(getIt<NotificationService>().init());
}
