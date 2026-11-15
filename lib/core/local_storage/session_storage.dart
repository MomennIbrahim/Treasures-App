// core/storage/session_storage.dart
import 'package:konoz/core/constance/app_keys.dart';
import 'package:konoz/core/local_storage/app_cache_keys.dart';
import 'package:konoz/core/local_storage/secure_cache.dart';
import 'package:konoz/features/auth/data/model/user_model.dart';

abstract class SessionStorage {
  static Future<void> save(AuthResponseModel auth) async {
    AppConstance.userToken = auth.token;
    AppConstance.refreshToken = auth.refreshToken;
    AppConstance.userId = auth.user.id;
    await SecureCache.setData(key: AppCacheKeys.accessToken, value: auth.token);
    await SecureCache.setData(
      key: AppCacheKeys.refreshToken,
      value: auth.refreshToken,
    );
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
