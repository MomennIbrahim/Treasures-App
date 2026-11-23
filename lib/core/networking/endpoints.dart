class EndPoint {
  EndPoint._();

  /// غيّره بـ: flutter run --dart-define=URL_APP=https://your-domain.com
  /// ملحوظة: على Android emulator استخدم http://10.0.2.2:8000 بدل localhost.
  // بدل الـ domain الحالي (الـ key الأول غلط، ده اسم الـ define مش الرابط)
  static const String domain = String.fromEnvironment(
    'URL_APP',
    // defaultValue: 'https://konoz.valien.tech', //https://rugged-unfamiliarised-celine.ngrok-free.dev
    defaultValue: 'https://konoz.valien.tech',
  );

  static const String baseUrl = '$domain/api/v1';

  // ───────────────────────── المصادقة (Auth) ─────────────────────────

  /// POST - name, phone, password
  static const String register = '/auth/register';

  /// POST - phone, password
  static const String login = '/auth/login';

  /// POST - id_token
  static const String googleLogin = '/auth/google';

  /// POST - refresh_token
  static const String refreshToken = '/auth/refresh';

  /// POST - يتطلب Bearer token
  static const String logout = '/auth/logout';

  /// GET - يتطلب Bearer token
  static const String me = '/auth/me';

  // ─────────────── المجموعات والمنتجات والتقييمات ───────────────

  /// GET
  static const String collections = '/collections';

  /// GET - اختياري: ?collection=id
  static const String products = '/products';

  /// GET
  static String productDetails(String productId) => '/products/$productId';

  /// POST - name, rating, review
  static String productReviews(String productId) =>
      '/products/$productId/reviews';

  // ───────────────────────── الصفحة الرئيسية ─────────────────────────

  /// GET
  static const String trending = '/trending';

  /// GET
  static const String topSellers = '/top-sellers';

  /// GET
  static const String welcomeSentences = '/welcome-sentences';

  // ───────────────── البانرات والعروض والترويجات ─────────────────

  /// GET
  static const String banners = '/banners';

  /// GET
  static const String promotions = '/promotions';

  /// GET
  static String promotionDetails(int promotionId) => '/promotions/$promotionId';

  /// POST - customer_id, lines, gifts
  static String promotionQuote(int promotionId) =>
      '/promotions/$promotionId/quote';

  /// POST - customer_id, order_id, gift_product_id
  static String promotionUses(int promotionId) =>
      '/promotions/$promotionId/uses';

  /// GET
  static const String offers = '/offers';

  // ───────────────────────────── الباقات ─────────────────────────────

  /// GET
  static const String packages = '/packages';

  /// GET
  static String packageDetails(String packageId) => '/packages/$packageId';

  // ──────────────────────────── عجلة الحظ ────────────────────────────

  /// GET
  static const String spinWheel = '/spin-wheel';
  static const String spinWheelSpins = '/spin-wheel/spins';

  /// GET حالة العجلة / POST لف العجلة
  /// (لسه بـ userId — لو الـ API بقى بالتوكن بس بدّله زي السلة)
  static String userSpinWheel(int userId) => '/users/$userId/spin-wheel';

  // ───────────────────────── العميل والعناوين ─────────────────────────

  /// POST - multipart/form-data
  static const String createUser = '/users';

  /// POST إضافة عنوان (title, fullAddress, isDefault, lat, lng)
  static const String addresses = '/addresses';

  /// PATCH تعديل / DELETE حذف
  static String address(int id) => '/addresses/$id';

  /// POST تعيينه كعنوان افتراضي
  static String addressDefault(int id) => '/addresses/$id/default';

  // ───────────────────────────── السلة ─────────────────────────────

  /// GET عرض السلة / POST إضافة (product_id, size, quantity)
  static const String cart = '/cart';

  /// PATCH تعديل الكمية / DELETE حذف السطر
  static String cartItem(int itemId) => '/cart/$itemId';

  // ───────────────────────── الدفع والطلبات ─────────────────────────

  /// GET
  static const String checkout = '/checkout';

  /// GET القائمة (?filter=last_30_days | this_year)
  /// POST إنشاء طلب (address_id, payment_method, coupon)
  static const String orders = '/orders';
  static String cancelOrder(int orderId) => '/orders/$orderId/cancel';
  static const String devices = '/devices';

  /// GET
  static String orderDetails(int orderId) => '/orders/$orderId';

  static const productsSearch = '/products/search';
  static const productsSuggestions = '/products/suggestions';
  static const searchTrending = '/search/trending'; // مقترح للباك إند
  static const searchLog = '/search/log'; // مقترح للباك إند
}
