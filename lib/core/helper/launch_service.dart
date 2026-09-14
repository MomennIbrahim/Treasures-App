import 'package:url_launcher/url_launcher.dart';

class LaunchService {
  const LaunchService._();

  static Future<void> call(String phone) => _launch('tel:$phone');

  static Future<void> email(String email) => _launch('mailto:$email');

  static Future<void> url(String url) => _launch(url);

  static Future<void> map({required double lat, required double lng}) =>
      _launch('https://www.google.com/maps/search/?api=1&query=$lat,$lng');

  static Future<void> whatsapp(String phone, {String message = ''}) =>
      _launch('https://wa.me/$phone?text=${Uri.encodeComponent(message)}');

  static Future<void> instagram(String username) async {
    final appUri = Uri.parse('instagram://user?username=$username');
    final webUri = Uri.parse('https://www.instagram.com/$username');

    try {
      final launched = await launchUrl(
        appUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await _launch(webUri.toString());
      }
    } catch (_) {
      await _launch(webUri.toString());
    }
  }

  static Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> facebook({String? pageId, String? username}) async {
    final String appUri;
    if (pageId != null) {
      appUri = 'fb://page/$pageId';
    } else {
      appUri = 'fb://facewebmodal/f?href=https://www.facebook.com/$username';
    }

    final webUri = 'https://www.facebook.com/${username ?? pageId}';

    try {
      final launched = await launchUrl(
        Uri.parse(appUri),
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await _launch(webUri);
      }
    } catch (_) {
      await _launch(webUri);
    }
  }

  static Future<void> tiktok(String username) async {
    final appUri = Uri.parse('snssdk1233://user/profile/$username');
    final webUri = Uri.parse('https://www.tiktok.com/@$username');

    try {
      final launched = await launchUrl(
        appUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await _launch(webUri.toString());
      }
    } catch (_) {
      await _launch(webUri.toString());
    }
  }
}
