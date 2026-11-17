import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:konoz/core/constance/app_keys.dart'; // AppConstance
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/core/networking/endpoints.dart'; // EndPoint
import 'package:konoz/core/notifications/notification_target.dart';
import 'package:konoz/core/theme/app_colors.dart';

class NotificationService {
  NotificationService(this._router, this._api);

  final GoRouter _router;
  final ApiService _api;

  final _local = FlutterLocalNotificationsPlugin();
  final _initialLoaded = Completer<void>();

  Map<String, dynamic>? _pending;
  String? _lastToken;
  bool _started = false;

  static const _channel = AndroidNotificationChannel(
    'konoz_default',
    'Konoz',
    importance: Importance.high,
  );

  /// نادِها مرة واحدة بعد `Firebase.initializeApp()` و `setupGetIt()`.
  /// الأفضل من غير await قبل runApp (requestPermission ممكن يستنى اليوزر).
  Future<void> init() async {
    if (_started) return;
    _started = true;
    final fm = FirebaseMessaging.instance;

    // 1) لو التطبيق اتفتح من إشعار وهو مقفول (Terminated).
    //    بنخزّنه لحد ما الهوم يجهز (flushPending).
    //    بنخلّص _initialLoaded هنا قبل requestPermission، عشان
    //    flushPending ماتستناش اليوزر يرد على نافذة الصلاحية.
    try {
      final initial = await fm.getInitialMessage();
      if (initial != null) _pending = Map.of(initial.data);
    } catch (e) {
      debugPrint('getInitialMessage failed: $e');
    } finally {
      if (!_initialLoaded.isCompleted) _initialLoaded.complete();
    }

    // 2) الصلاحيات (iOS و Android 13+). مرة واحدة بس.
    try {
      await fm.requestPermission();
    } catch (e) {
      debugPrint('requestPermission failed: $e');
    }

    if (kDebugMode) unawaited(_logToken());

    // 3) الإشعارات المحلية (عشان نعرض إشعار والتطبيق مفتوح).
    //    الصلاحيات بتتطلب من requestPermission فوق، فمش محتاجينها هنا.
    await _local.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@drawable/ic_notification'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (r) {
        final p = r.payload;
        if (p == null || p.isEmpty) return;
        try {
          open(Map<String, dynamic>.from(jsonDecode(p) as Map));
        } catch (_) {}
      },
    );
    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    // 4) التطبيق مفتوح (Foreground): مش بيظهر إشعار لوحده، فبنعرضه محلي.
    //    (مش بنفعّل setForegroundNotificationPresentationOptions عشان
    //     iOS ميعرضوش مرتين.)
    FirebaseMessaging.onMessage.listen((m) {
      // الإشعار العربي: من notification، أو من ar_title/ar_body في الـ data.
      final title = m.notification?.title ?? m.data['ar_title']?.toString();
      final body = m.notification?.body ?? m.data['ar_body']?.toString();
      if (title == null && body == null) return;

      _local.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            importance: Importance.high,
            priority: Priority.high,
            color: AppColors.primary,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: jsonEncode(m.data),
      );
    });

    // 5) التطبيق في الـ Background واليوزر ضغط على الإشعار.
    FirebaseMessaging.onMessageOpenedApp.listen((m) => open(m.data));

    // 6) تجديد التوكن (على iOS أول توكن بيوصل من هنا لما الـ APNs يجهز).
    fm.onTokenRefresh.listen((t) => registerToken(t));
  }

  /// بيرجّع FCM token. على iOS بينتظر الـ APNs token الأول
  /// (لو ما جاش، زي الـ simulator، بيرجّع null).
  Future<String?> _fcmToken() async {
    final fm = FirebaseMessaging.instance;
    if (Platform.isIOS) {
      var apns = await fm.getAPNSToken();
      for (var i = 0; apns == null && i < 5; i++) {
        await Future.delayed(const Duration(seconds: 1));
        apns = await fm.getAPNSToken();
      }
      if (apns == null) return null;
    }
    return fm.getToken();
  }

  Future<void> _logToken() async {
    try {
      debugPrint('FCM TOKEN: ${await _fcmToken()}');
    } catch (e) {
      debugPrint('FCM TOKEN error: $e');
    }
  }

  /// تتنادى من HomeScreen.initState:
  /// `WidgetsBinding.instance.addPostFrameCallback(
  ///    (_) => getIt<NotificationService>().flushPending());`
  Future<void> flushPending() async {
    await _initialLoaded.future;
    final p = _pending;
    _pending = null;
    if (p != null) open(p);
  }

  /// بيفتح الوجهة. بيستخدمه الـ Push والـ Inbox.
  /// [data] لازم فيه `event`.
  void open(Map<String, dynamic> data) {
    final t = resolveNotificationTarget(data);
    if (t == null) return;
    _router.go(t.location, extra: t.extra);
  }

  /// بعد اللوجين وبعد `/auth/me` عند فتح التطبيق.
  Future<void> registerToken([String? token]) async {
    if (AppConstance.userToken == null) return;
    try {
      token ??= await _fcmToken();
      if (token == null || token.isEmpty) return;
      await _api.postData(
        endPoint: EndPoint.devices,
        data: {'token': token, 'platform': Platform.isIOS ? 'ios' : 'android'},
      );
      _lastToken = token;
    } catch (e) {
      // مش مهم يوقف الدخول: الـ Inbox شغال حتى من غير Push.
      debugPrint('registerToken failed: $e');
    }
  }

  /// لازم تتنادى **قبل** `SessionStorage.clear()` في الـ logout
  /// (الـ DELETE محتاج توكن العميل).
  /// DELETE محتاج body فيه التوكن، و 404 معناها مش مسجّل عنده (بنتجاهله).
  Future<void> unregisterToken() async {
    try {
      final token = _lastToken ?? await _fcmToken();
      if (token == null || token.isEmpty) return;
      await _api.deleteData(endPoint: EndPoint.devices, data: {'token': token});
    } catch (e) {
      debugPrint('unregisterToken failed: $e');
    } finally {
      _lastToken = null;
    }
  }
}