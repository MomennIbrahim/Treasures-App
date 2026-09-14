import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:konoz/generated/locale_keys.g.dart';
 
abstract class AppFailure {
  final String message;
  final int? statusCode;
  final dynamic errors;

  const AppFailure(this.message, [this.statusCode, this.errors]);

  String getAllError() {
    if (errors != null && errors is Map && (errors as Map).isNotEmpty) {
      return (errors as Map).entries
          .map((entry) {
            final messages = entry.value as List;
            return messages.join(', ');
          })
          .join('\n');
    }
    return message;
  }
}

class RemoteServerFailure extends AppFailure {
  const RemoteServerFailure(super.message, [super.statusCode, super.errors]);

  factory RemoteServerFailure.fromDioError(DioException dioException) {
    if (dioException.type == DioExceptionType.connectionTimeout ||
        dioException.type == DioExceptionType.sendTimeout ||
        dioException.type == DioExceptionType.receiveTimeout) {
      return RemoteServerFailure(LocaleKeys.errors_errors_timeout.tr(), 408);
    }

    if (dioException.type == DioExceptionType.connectionError ||
        dioException.type == DioExceptionType.unknown) {
      return RemoteServerFailure(LocaleKeys.errors_errors_no_internet.tr(), 0);
    }

    if (dioException.response != null) {
      return RemoteServerFailure.fromResponse(
        dioException.response!.statusCode,
        dioException.response!.data,
      );
    }

    return RemoteServerFailure(LocaleKeys.errors_errors_unexpected.tr(), 0);
  }

  factory RemoteServerFailure.fromResponse(int? statusCode, dynamic response) {
    String extractedMessage = LocaleKeys.errors_errors_unexpected.tr();
    dynamic extractedErrors;

    if (response is Map<String, dynamic>) {
      // ── النمط القديم: { "message": "..." } ──
      if (response.containsKey('message') && response['message'] is String) {
        extractedMessage = response['message'];
      }

      // ── النمط الجديد: { "error": { "message": "...", "errors": {} } } ──
      if (response.containsKey('error') && response['error'] is Map) {
        final error = response['error'] as Map<String, dynamic>;
        if (error.containsKey('message') && error['message'] is String) {
          extractedMessage = error['message'];
        }
        if (error.containsKey('errors')) {
          extractedErrors = error['errors'];
        }
      }

      if (response.containsKey('errors')) {
        extractedErrors = response['errors'];
      }
    } else if (response is String && response.isNotEmpty) {
      extractedMessage = response;
    }

    switch (statusCode) {
      case 400:
      case 403:
      case 404:
      case 422: // 👈
        return RemoteServerFailure(
          extractedMessage,
          statusCode,
          extractedErrors,
        );
      case 500:
        return RemoteServerFailure(
          LocaleKeys.errors_errors_internal_server_error.tr(),
          500,
        );
      default:
        return RemoteServerFailure(
          extractedMessage,
          statusCode,
          extractedErrors,
        );
    }
  }
}

