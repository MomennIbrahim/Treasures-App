import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:konoz/core/constance/app_keys.dart';
import 'package:konoz/core/error/app_exception.dart';
import 'package:konoz/core/local_storage/session_storage.dart';
import 'package:konoz/core/networking/connectivity_service.dart';
import 'package:konoz/core/networking/endpoints.dart';
import 'package:konoz/generated/locale_keys.g.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:requests_inspector/requests_inspector.dart';

class ApiService {
  ApiService(this._dio, this._connectivityService) {
    _initDio();
  }

  final Dio _dio;
  final ConnectivityService _connectivityService;

  Dio get dio => _dio;

  // ══════════════════ نقط الربط مع الـ storage (عدّلها لو الأسماء مختلفة) ══════════════════

  /// الـ refresh token المحفوظ (null = مفيش جلسة)
  String? _readRefreshToken() => AppConstance.refreshToken;

  /// بيحفظ الـ tokens الجديدة (بيحدّث AppConstance.userToken كمان)
  Future<void> _saveTokens({required String access, String? refresh}) =>
      SessionStorage.save(
        accessToken: access,
        refreshToken: refresh ?? AppConstance.refreshToken,
      );

  // ═══════════════════════════════════════════════════════════════════════════════════════

  void _initDio() {
    _dio.options = BaseOptions(
      baseUrl: EndPoint.baseUrl,
      receiveDataWhenStatusError: true,
      followRedirects: false,
      connectTimeout: const Duration(minutes: 1),
      receiveTimeout: const Duration(minutes: 1),
      sendTimeout: const Duration(minutes: 1),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    _addInterceptors();
  }

  void _addInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Accept-Language'] =
              AppConstance.currentLanguage ?? 'ar';

          if (AppConstance.userToken != null) {
            options.headers['Authorization'] =
                'Bearer ${AppConstance.userToken}';
          }

          return handler.next(options);
        },
      ),
    );

    // لازم بعد interceptor الـ headers: عند إعادة الطلب بيتحط التوكن الجديد تلقائيًا
    _dio.interceptors.add(_refreshInterceptor());

    if (kDebugMode) {
      _dio.interceptors.add(RequestsInspectorInterceptor());
    }

    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          request: true,
          responseHeader: true,
          requestBody: true,
        ),
      );
    }
  }

  // ══════════════════════════ Refresh token ══════════════════════════

  /// مسارات الـ auth ما بنجدّدش عليها (غلط بيانات الدخول مش انتهاء توكن)
  static const _noRefreshPaths = {
    EndPoint.login,
    EndPoint.register,
    EndPoint.googleLogin,
    EndPoint.refreshToken,
    EndPoint.logout,
  };

  static const _retriedKey = 'token_refreshed';

  /// عملية تجديد واحدة بس في نفس الوقت، وباقي الطلبات اللي فشلت بـ 401 بتستناها
  Future<bool>? _refreshing;

  Interceptor _refreshInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        final req = error.requestOptions;

        final canRefresh =
            error.response?.statusCode == 401 &&
            req.extra[_retriedKey] != true &&
            !_noRefreshPaths.contains(req.path) &&
            _readRefreshToken() != null;
        if (!canRefresh) return handler.next(error);

        // لو التوكن اتجدد بالفعل بعد ما الطلب ده اتبعت، نعيده بس من غير تجديد تاني
        final sentWith = req.headers['Authorization'];
        final alreadyRefreshed =
            AppConstance.userToken != null &&
            sentWith != 'Bearer ${AppConstance.userToken}';

        final ok = alreadyRefreshed
            ? true
            : await (_refreshing ??= _refreshTokens().whenComplete(
                () => _refreshing = null,
              ));
        if (!ok) return handler.next(error); // هيتحوّل لـ UnauthorizedException

        try {
          final retry = req.copyWith(
            extra: {...req.extra, _retriedKey: true},
            // الـ FormData بيتقفل بعد أول إرسال، فبنعمله clone
            data: req.data is FormData
                ? (req.data as FormData).clone()
                : req.data,
          );
          handler.resolve(await _dio.fetch<dynamic>(retry));
        } on DioException catch (e) {
          handler.next(e);
        }
      },
    );
  }

  /// POST /auth/refresh { refresh_token } → access + refresh جداد.
  /// بنستخدم Dio منفصل (من غير interceptors) عشان مفيش loop.
  Future<bool> _refreshTokens() async {
    final refresh = _readRefreshToken();
    if (refresh == null || refresh.isEmpty) return false;

    try {
      final plain = Dio(
        BaseOptions(
          baseUrl: EndPoint.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );
      final res = await plain.post<dynamic>(
        EndPoint.refreshToken,
        data: {'refresh_token': refresh},
      );

      final body = res.data;
      final Map data = body is Map
          ? (body['data'] is Map ? body['data'] as Map : body)
          : const {};
      final access = (data['access_token'] ?? data['token'])?.toString();
      if (access == null || access.isEmpty) return false;

      await _saveTokens(
        access: access,
        refresh: data['refresh_token']?.toString(),
      );
      return true;
    } on DioException catch (e) {
      // الـ refresh token نفسه مرفوض/منتهي: الجلسة خلصت فعلًا.
      // (أخطاء الشبكة ما بنطلّعش اليوزر بسببها)
      final code = e.response?.statusCode;
      if (code == 400 || code == 401 || code == 422) {
        await SessionStorage.clear();
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  // ══════════════════════════ الطلبات ══════════════════════════

  Future<Response<dynamic>> getData({
    required String endPoint,
    Map<String, dynamic>? query,
    dynamic data,
  }) => _send(() => _dio.get(endPoint, queryParameters: query, data: data));

  Future<Response<dynamic>> postData({
    required String endPoint,
    Map<String, dynamic>? query,
    dynamic data,
  }) => _send(
    () => _dio.post(
      endPoint,
      queryParameters: query,
      data: data,
      options: _optionsFor(data),
    ),
  );

  Future<Response<dynamic>> putData({
    required String endPoint,
    Map<String, dynamic>? query,
    dynamic data,
  }) => _send(
    () => _dio.put(
      endPoint,
      queryParameters: query,
      data: data,
      options: _optionsFor(data),
    ),
  );

  Future<Response<dynamic>> patchData({
    required String endPoint,
    Map<String, dynamic>? query,
    dynamic data,
  }) => _send(
    () => _dio.patch(
      endPoint,
      queryParameters: query,
      data: data,
      options: _optionsFor(data),
    ),
  );

  Future<Response<dynamic>> deleteData({
    required String endPoint,
    Map<String, dynamic>? query,
    dynamic data,
  }) => _send(() => _dio.delete(endPoint, queryParameters: query, data: data));

  Options? _optionsFor(dynamic data) =>
      data is FormData ? Options(contentType: 'multipart/form-data') : null;

  Future<Response<dynamic>> _send(
    Future<Response<dynamic>> Function() request,
  ) async {
    if (!await _connectivityService.refresh()) {
      throw const ConnectionException();
    }

    try {
      return await request();
    } on DioException catch (error) {
      throw _toAppException(error);
    }
  }

  AppException _toAppException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const ConnectionException(LocaleKeys.errors_errors_timeout);
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return const ConnectionException();
      case DioExceptionType.cancel:
        return const ConnectionException(LocaleKeys.errors_request_cancelled);
      case DioExceptionType.badCertificate:
        return const ConnectionException(LocaleKeys.errors_bad_certificate);
      case DioExceptionType.badResponse:
        return _fromBadResponse(error.response);
    }
  }

  AppException _fromBadResponse(Response<dynamic>? response) {
    final statusCode = response?.statusCode;

    if (statusCode == 401) {
      return const UnauthorizedException();
    }

    final body = response?.data;
    if (body is Map<String, dynamic>) {
      final message = (body['message'] ?? '').toString();
      return RequestException(
        message.trim().isEmpty
            ? LocaleKeys.errors_errors_internal_server_error
            : message,
        statusCode: statusCode,
        fieldErrors: _fieldErrorsOf(body['errors']),
      );
    }

    return RequestException(
      LocaleKeys.errors_errors_internal_server_error,
      statusCode: statusCode,
    );
  }

  Map<String, String> _fieldErrorsOf(dynamic errors) {
    if (errors is! Map) return const {};
    final flattened = <String, String>{};
    errors.forEach((key, value) {
      if (value is List && value.isNotEmpty) {
        flattened[key.toString()] = value.first.toString();
      } else if (value is String) {
        flattened[key.toString()] = value;
      }
    });
    return flattened;
  }
}
