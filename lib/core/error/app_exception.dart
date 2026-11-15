sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

class ConnectionException extends AppException {
  const ConnectionException([super.message = 'no_internet_connection']);
}

class RequestException extends AppException {
  const RequestException(
    super.message, {
    this.statusCode,
    this.fieldErrors = const {},
  });

  final int? statusCode;
  final Map<String, String> fieldErrors;

  bool get isValidation => statusCode == 422 || fieldErrors.isNotEmpty;
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'session_expired']);
}

class CacheException extends AppException {
  const CacheException([super.message = 'cache_error']);
}
