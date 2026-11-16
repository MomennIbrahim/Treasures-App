// core/storage/session_storage.dart
import 'package:konoz/core/constance/app_keys.dart';
import 'package:konoz/core/local_storage/app_cache_keys.dart';
import 'package:konoz/core/local_storage/secure_cache.dart';

abstract class SessionStorage {
  static Future<void> save({
    required String accessToken,
    String? refreshToken,
  }) async {
    AppConstance.userToken = accessToken;
    await SecureCache.setData(
      key: AppCacheKeys.accessToken,
      value: accessToken,
    );

    if (refreshToken != null) {
      AppConstance.refreshToken = refreshToken;
      await SecureCache.setData(
        key: AppCacheKeys.refreshToken,
        value: refreshToken,
      );
    }
  }

  static Future<void> load() async {
    AppConstance.userToken = await SecureCache.getData(
      key: AppCacheKeys.accessToken,
    );
    AppConstance.refreshToken = await SecureCache.getData(
      key: AppCacheKeys.refreshToken,
    );
  }

  static Future<void> clear() async {
    AppConstance.userToken = null;
    AppConstance.refreshToken = null;
    AppConstance.userId = null;
    await SecureCache.removeData(key: AppCacheKeys.accessToken);
    await SecureCache.removeData(key: AppCacheKeys.refreshToken);
  }
}
