
import 'dart:async';

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

  factory RemoteServerFailure.from(Object error) {
    if (error is TimeoutException) {
      return RemoteServerFailure.timeout();
    }

    final text = error.toString().toLowerCase();

    if (text.contains('socketexception') ||
        text.contains('failed host lookup') ||
        text.contains('clientexception') ||
        text.contains('connection refused') ||
        text.contains('network')) {
      return RemoteServerFailure.noInternet();
    }

    return RemoteServerFailure(
      LocaleKeys.errors_errors_unexpected.tr(),
      0,
    );
  }

  factory RemoteServerFailure.timeout() =>
      RemoteServerFailure(LocaleKeys.errors_errors_timeout.tr(), 408);

  factory RemoteServerFailure.noInternet() =>
      RemoteServerFailure(LocaleKeys.errors_errors_no_internet.tr(), 0);
}
