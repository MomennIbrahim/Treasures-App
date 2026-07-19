 import 'package:easy_localization/easy_localization.dart' show BuildContextEasyLocalizationExtension;
import 'package:flutter/material.dart';

 
extension LocaleExtension on BuildContext {
  /// Returns the current locale (e.g. Locale('ar'), Locale('en')).
  Locale get currentLocale => locale;

  /// Returns the current language code only (e.g. 'ar', 'en').
  String get currentLanguageCode => locale.languageCode;

  /// True if the current language is Arabic.
  bool get isArabic => currentLanguageCode == 'ar';

  /// True if the current language is English.
  bool get isEnglish => currentLanguageCode == 'en';

  /// True if the current text direction is RTL.
  bool get isRTL => Directionality.of(this) == TextDirection.rtl;

  /// True if the current text direction is LTR.
  bool get isLTR => Directionality.of(this) == TextDirection.ltr;

  /// Generic check against any language code.
  bool isLanguage(String code) => currentLanguageCode == code;
}
