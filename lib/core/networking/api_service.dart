import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:konoz/core/constance/app_keys.dart';
import 'package:konoz/core/error/app_exception.dart';
import 'package:konoz/core/networking/connectivity_service.dart';
import 'package:konoz/core/networking/endpoints.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:requests_inspector/requests_inspector.dart';

class ApiService {
  ApiService(this._dio, this._connectivityService) {
    _initDio();
  }

  final Dio _dio;
  final ConnectivityService _connectivityService;

  Dio get dio => _dio;

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
        return const ConnectionException('request_timeout');
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return const ConnectionException();
      case DioExceptionType.cancel:
        return const ConnectionException('request_cancelled');
      case DioExceptionType.badCertificate:
        return const ConnectionException('bad_certificate');
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
        message.trim().isEmpty ? 'server_error' : message,
        statusCode: statusCode,
        fieldErrors: _fieldErrorsOf(body['errors']),
      );
    }

    return RequestException('server_error', statusCode: statusCode);
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
