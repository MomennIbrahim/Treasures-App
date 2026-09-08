// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> _en = {
  "layout": {
    "home": "Home",
    "collections": "Collections",
    "about_us": "About Us",
    "contact_us": "Contact Us"
  },
  "home": {
    "a_better_mood_starts_with_konooz": "A Better Mood Starts With KONOOZ",
    "exclusive_offers": "Exclusive Offers 🔥",
    "currently_trending": "Currently Trending",
    "best_selling": "Best Selling",
    "packages": "Packages"
  },
  "collections": {
    "featured_collections": "FEATURED COLLECTIONS",
    "featured_collections_description": "Discover the fragrance everyone's talking about - bold, unique, and made to be your signature scent."
  },
  "errors": {
    "errors_timeout": "Connection timed out. Please try again.",
    "errors_no_internet": "No internet connection. Please check your connection.",
    "errors_unexpected": "An unexpected error occurred. Please try again.",
    "errors_internal_server_error": "Internal server error. Please try again later."
  }
};
static const Map<String,dynamic> _ar = {
  "layout": {
    "home": "الصفحة الرئيسية",
    "collections": "المجموعات",
    "about_us": "من نحن",
    "contact_us": "اتصل بنا"
  },
  "home": {
    "a_better_mood_starts_with_konooz": "مزاج أفضل يبدأ مع كنوز",
    "exclusive_offers": "عروض حصرية 🔥",
    "currently_trending": "الأكثر رواجًا حاليًا",
    "best_selling": "الأكثر مبيعًا",
    "packages": "الباقات"
  },
  "collections": {
    "featured_collections": "مجموعات مميزة",
    "featured_collections_description": "اكتشف العطر الذي يتحدث عنه الجميع - جريء، مميز، ومصمم ليكون عطرك المميز."
  },
  "errors": {
    "errors_timeout": "انتهت مهلة الاتصال. حاول مرة أخرى.",
    "errors_no_internet": "لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصالك.",
    "errors_unexpected": "حدث خطأ غير متوقع. حاول مرة أخرى.",
    "errors_internal_server_error": "حدث خطأ في الخادم. حاول مرة أخرى لاحقًا."
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": _en, "ar": _ar};
}
