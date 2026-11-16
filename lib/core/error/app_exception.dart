import 'package:easy_localization/easy_localization.dart';
import 'package:konoz/generated/locale_keys.g.dart';

/// بتشيل مفتاح ترجمة (const) أو نص خام جاي من السيرفر.
/// الترجمة بتحصل وقت قراءة [message] مش وقت إنشاء الـ exception،
/// عشان الـ constructors تفضل const (`.tr()` مش const).
sealed class AppException implements Exception {
  const AppException(this._raw);

  final String _raw;

  /// مفاتيح LocaleKeys بتبدأ بـ "errors." (مثلًا errors.session_expired)
  static const _keyPrefix = 'errors.';

  /// النص الجاهز للعرض (مترجم لو كان مفتاح، أو رسالة السيرفر زي ما هي)
  String get message => _raw.startsWith(_keyPrefix) ? _raw.tr() : _raw;

  @override
  String toString() => '$runtimeType: $message';
}

class ConnectionException extends AppException {
  const ConnectionException([
    super.message = LocaleKeys.errors_errors_no_internet,
  ]);
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
  const UnauthorizedException([
    super.message = LocaleKeys.errors_session_expired,
  ]);
}

class CacheException extends AppException {
  const CacheException([super.message = LocaleKeys.errors_cache_error]);
}
