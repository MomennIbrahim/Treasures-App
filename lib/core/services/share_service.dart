import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

/// بيبني لينك الـ deep link ويفتح شيت المشاركة.
/// الدومين والمسارات لازم تتطابق مع اللي الباك اند هيجهزه
/// (assetlinks.json / apple-app-site-association) ومع routes الـ router.
class ShareService {
  ShareService._();

  // TODO: أكد الدومين النهائي مع الباك اند
  static const String _baseUrl = 'https://konoz.valien.tech';

  static String productLink(String productId) =>
      '$_baseUrl/products/$productId';
  static String packageLink(String packageId) =>
      '$_baseUrl/packages/$packageId';

  static Future<void> shareProduct(
    BuildContext context, {
    required String id,
    required String name,
  }) => _share(context, title: name, link: productLink(id));

  static Future<void> sharePackage(
    BuildContext context, {
    required String id,
    required String name,
  }) => _share(context, title: name, link: packageLink(id));

  static Future<void> _share(
    BuildContext context, {
    required String title,
    required String link,
  }) async {
    // iPad محتاج مكان يطلع منه الشيت
    final box = context.findRenderObject() as RenderBox?;
    final origin = box == null
        ? null
        : box.localToGlobal(Offset.zero) & box.size;

    await SharePlus.instance.share(
      ShareParams(
        text: '$title\n$link',
        subject: title,
        sharePositionOrigin: origin,
      ),
    );
  }
}
