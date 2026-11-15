import 'package:easy_localization/easy_localization.dart';
import 'package:konoz/generated/locale_keys.g.dart';

String? validateEgyptianPhone(String? value) {
  if (value == null || value.isEmpty) {
    return LocaleKeys.validation_please_enter_phone.tr();
  }
  final egyptianPhoneRegex = RegExp(r'^01[0125][0-9]{8}$');
  if (!egyptianPhoneRegex.hasMatch(value)) {
    return LocaleKeys.validation_invalid_phone.tr();
  }
  return null;
}

/// 01069528769 -> 201069528769 (الشكل اللي الـ API بيخزنه)
String toApiPhone(String raw) => '20${raw.trim().substring(1)}';
