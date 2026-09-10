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

  static const Map<String,dynamic> _ar = {
  "general": {
    "add_to_cart": "اضافة الى السلة",
    "search_hint": "ابحث عن عطر...",
    "undo": "الغاء",
    "show_details": "اظهار التفاصيل"
  },
  "layout": {
    "home": "الرئيسية",
    "collections": "الفئات",
    "cart": "السلة",
    "me": "أنا"
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
  "me": {
    "personal_data": "حسابي",
    "orders": "الطلبات",
    "favorites": "المفضلة",
    "faq": "الأسئلة الشائعة",
    "community": "المجتمع",
    "settings": "الإعدادات",
    "help_hint": "لا تتردد في السؤال، نحن مستعدون لمساعدتك",
    "logout": "تسجيل الخروج"
  },
  "product_details": {
    "longevity": "الثبات",
    "sillage": "الفوحان",
    "description": "الوصف",
    "how_to_use": "طريقة الأستخدام",
    "notes": "المكونات",
    "details": "التفاصيل",
    "reviews": "التقييمات",
    "top_notes": "المكونات العليا",
    "heart_notes": "قلب العطر",
    "base_notes": "المكونات الأساسية"
  },
  "cart": {
    "proceed_to_buy": "المتابعة للشراء",
    "items": "المنتجات",
    "summary_order": "ملخص الطلب",
    "coast": "السعر",
    "shipping": "الشحن",
    "tax": "الضريبة",
    "discount": "الخصم",
    "total": "الأجمالي"
  },
  "errors": {
    "errors_timeout": "انتهت مهلة الاتصال. حاول مرة أخرى.",
    "errors_no_internet": "لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصالك.",
    "errors_unexpected": "حدث خطأ غير متوقع. حاول مرة أخرى.",
    "errors_internal_server_error": "حدث خطأ في الخادم. حاول مرة أخرى لاحقًا."
  }
};
static const Map<String,dynamic> _en = {
  "general": {
    "add_to_cart": "Add to Cart",
    "search_hint": "Search for perfumery or fragrances...",
    "undo": "Undo",
    "show_details": "Show Details"
  },
  "layout": {
    "home": "Home",
    "collections": "Collections",
    "cart": "Cart",
    "me": "Me"
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
  "me": {
    "personal_data": "Personal Data",
    "orders": "Orders",
    "favorites": "Favorites",
    "faq": "FAQ",
    "community": "Community",
    "settings": "Settings",
    "help_hint": "Fell free to Ask, We Ready to Help",
    "logout": "Logout"
  },
  "product_details": {
    "longevity": "Longevity",
    "sillage": "Sillage",
    "description": "Description",
    "how_to_use": "How To Use",
    "notes": "Notes",
    "details": "Details",
    "reviews": "Reviews",
    "base_notes": "Base Notes",
    "heart_notes": "Heart Notes",
    "top_notes": "Top Notes"
  },
  "cart": {
    "proceed_to_buy": "Proceed to Buy",
    "items": "Items",
    "summary_order": "Summary Order",
    "coast": "Coast",
    "shipping": "Shipping",
    "tax": "Tax",
    "discount": "Discount",
    "total": "Total"
  },
  "errors": {
    "errors_timeout": "Connection timed out. Please try again.",
    "errors_no_internet": "No internet connection. Please check your connection.",
    "errors_unexpected": "An unexpected error occurred. Please try again.",
    "errors_internal_server_error": "Internal server error. Please try again later."
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"ar": _ar, "en": _en};
}
