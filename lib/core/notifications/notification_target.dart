// core/notifications/notification_target.dart
import 'package:konoz/core/notifications/offer_products_args.dart';
import 'package:konoz/core/router/routes.dart';

class NotificationTarget {
  final String location;
  final Object? extra;
  const NotificationTarget(this.location, [this.extra]);
}

NotificationTarget? resolveNotificationTarget(Map<String, dynamic> raw) {
  String? s(String k) {
    final v = raw[k]?.toString();
    return (v == null || v.isEmpty) ? null : v;
  }

  switch (s('event')) {
    case 'product_new':
    case 'new_product': // المثال في الملف بيستخدم الاسم ده
      final id = s('productId');
      return id == null ? null : NotificationTarget(
          '${Routes.home}/${Routes.productDetails}', id);

    case 'package_new':
    case 'new_package':
      final id = s('packageId');
      return id == null ? null : NotificationTarget(
          '${Routes.home}/${Routes.packageDetails}', id);

    case 'offer_new':
    case 'new_offer':
      final id = s('offerId');
      return id == null ? null : NotificationTarget(
          '${Routes.home}/${Routes.offerProducts}',
          OfferProductsArgs(offerId: id));

    case 'discount':
      if (s('productId') != null) {
        return NotificationTarget(
            '${Routes.home}/${Routes.productDetails}', s('productId'));
      }
      if (s('promotionId') != null) {
        return NotificationTarget('${Routes.home}/${Routes.offerProducts}',
            OfferProductsArgs(promotionId: s('promotionId')));
      }
      return NotificationTarget(Routes.home); // كوبون أو خصم العجلة

    case 'order_update':
      return NotificationTarget('${Routes.profile}/${Routes.orders}');

    case 'spin_wheel':
      return NotificationTarget('${Routes.home}/${Routes.spin}');
  }
  return null; // manual أو غير معروف
}