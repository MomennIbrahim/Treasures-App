/// الـ extra بتاع راوت `offer-products`.
/// مكانه المقترح: features/offer_products/data/model/offer_products_args.dart
///
/// الشاشة تجيب المنتجات حسب اللي موجود:
///  - promotionId  -> GET /promotions/{id}
///  - offerId      -> GET /offers (وتفلتر على العرض ده)
///  - الاتنين null -> الـ mock القديم (لحد ما نشيله)
class OfferProductsArgs {
  const OfferProductsArgs({this.offerId, this.promotionId});

  final String? offerId;
  final String? promotionId;
}
