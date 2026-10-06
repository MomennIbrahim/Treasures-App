import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:konoz/generated/locale_keys.g.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AppFailure {
  final String message;
  final int? statusCode;
  final dynamic errors;

  const AppFailure(this.message, [this.statusCode, this.errors]);

  String getAllError() {
    if (errors != null && errors is Map && (errors as Map).isNotEmpty) {
      return (errors as Map).entries
          .map((entry) {
            final value = entry.value;
            return value is List ? value.join(', ') : value.toString();
          })
          .join('\n');
    }
    return message;
  }
}

class RemoteServerFailure extends AppFailure {
  const RemoteServerFailure(super.message, [super.statusCode, super.errors]);

  // ─────────────────────────────────────────────
  // نقطة الدخول: أي استثناء يتحول للنوع المناسب
  // (بديل fromDioError)
  // ─────────────────────────────────────────────
  factory RemoteServerFailure.from(Object error) {
    // انقطاع الشبكة في supabase
    if (error is AuthRetryableFetchException) {
      return RemoteServerFailure.noInternet();
    }

    if (error is AuthException) return RemoteServerFailure.fromAuth(error);

    if (error is PostgrestException) {
      return RemoteServerFailure.fromPostgrest(error);
    }

    // نفس حالات timeout القديمة (connection/send/receive)
    if (error is TimeoutException) return RemoteServerFailure.timeout();

    // بدون dart:io عشان يشتغل على الويب كمان
    final text = error.toString().toLowerCase();
    if (text.contains('socketexception') ||
        text.contains('failed host lookup') ||
        text.contains('clientexception') ||
        text.contains('connection refused') ||
        text.contains('network')) {
      return RemoteServerFailure.noInternet();
    }

    return RemoteServerFailure(LocaleKeys.errors_errors_unexpected.tr(), 0);
  }

  factory RemoteServerFailure.timeout() =>
      RemoteServerFailure(LocaleKeys.errors_errors_timeout.tr(), 408);

  factory RemoteServerFailure.noInternet() =>
      RemoteServerFailure(LocaleKeys.errors_errors_no_internet.tr(), 0);

  // ─────────────────────────────────────────────
  // أخطاء الأوث
  // ─────────────────────────────────────────────
  factory RemoteServerFailure.fromAuth(AuthException e) {
    final status = int.tryParse(e.statusCode ?? '');
    final msg = e.message.toLowerCase();
    final code = (e is AuthApiException ? e.code : null) ?? '';

    // نفس منطق fromResponse القديم: 400/403/404/422 برسالتها الأصلية
    // والـ 500 برسالة السيرفر الموحدة
    if (status == 500) {
      return RemoteServerFailure(
        LocaleKeys.errors_errors_internal_server_error.tr(),
        500,
      );
    }

    // كود غلط أو منتهي
    if (code == 'otp_expired' ||
        code == 'otp_disabled' ||
        msg.contains('expired') ||
        (msg.contains('invalid') && msg.contains('token'))) {
      return RemoteServerFailure(LocaleKeys.errors_invalid_otp.tr(), status);
    }

    // تجاوز حد الإرسال
    if (code == 'over_sms_send_rate_limit' ||
        code == 'over_request_rate_limit' ||
        status == 429 ||
        msg.contains('rate limit') ||
        msg.contains('too many')) {
      return RemoteServerFailure(LocaleKeys.errors_too_many_requests.tr(), 429);
    }

    // رقم غير صحيح
    if (msg.contains('phone') && msg.contains('invalid')) {
      return RemoteServerFailure(LocaleKeys.errors_invalid_phone.tr(), status);
    }

    // 422 يفضل بالـ statusCode الأصلي (الـ listener بيعتمد عليه)
    // مع رسالة الـ SMS provider المترجمة
    if (msg.contains('provider') ||
        msg.contains('twilio') ||
        code == 'sms_send_failed') {
      return RemoteServerFailure(LocaleKeys.errors_sms_failed.tr(), status);
    }

    // default: الرسالة الأصلية + الـ statusCode
    return RemoteServerFailure(
      e.message.isNotEmpty
          ? e.message
          : LocaleKeys.errors_errors_unexpected.tr(),
      status,
    );
  }

  // ─────────────────────────────────────────────
  // أخطاء الداتابيز
  // ─────────────────────────────────────────────
  factory RemoteServerFailure.fromPostgrest(PostgrestException e) {
    final status = int.tryParse(e.code ?? '');

    // RLS رفض الصلاحية
    if (e.code == '42501') {
      return RemoteServerFailure(LocaleKeys.errors_unauthorized.tr(), 403);
    }

    // قيمة مكررة
    if (e.code == '23505') {
      return RemoteServerFailure(LocaleKeys.errors_already_exists.tr(), 409);
    }

    // مفيش نتيجة
    if (e.code == 'PGRST116') {
      return RemoteServerFailure(LocaleKeys.errors_not_found.tr(), 404);
    }

    // أخطاء السيرفر الداخلية (كود 5xxxx أو XX000)
    if ((e.code ?? '').startsWith('XX') || status == 500) {
      return RemoteServerFailure(
        LocaleKeys.errors_errors_internal_server_error.tr(),
        500,
      );
    }

    // default: الرسالة الأصلية + تفاصيل الخطأ في errors
    return RemoteServerFailure(
      e.message.isNotEmpty
          ? e.message
          : LocaleKeys.errors_errors_unexpected.tr(),
      status,
      e.details,
    );
  }
}
