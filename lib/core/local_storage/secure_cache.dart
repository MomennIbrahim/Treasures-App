import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureCache {
  static AndroidOptions getAndroidOptions() =>
      const AndroidOptions(resetOnError: true);
  static IOSOptions getIOSOptions() =>
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  static late FlutterSecureStorage flutterSecureStorage;

  static void secureCacheInit() {
    flutterSecureStorage = FlutterSecureStorage(
      aOptions: getAndroidOptions(),
      iOptions: getIOSOptions(),
    );
  }

  // For simple string values
  static Future<void> setData({
    required String key,
    required dynamic value,
  }) async {
    return await flutterSecureStorage.write(
      key: key,
      value: value.toString(),
      iOptions: const IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ),
    );
  }

  // For complex objects (Map, List, etc.)
  static Future<void> setJsonData({
    required String key,
    required dynamic jsonData,
  }) async {
    final jsonString = jsonEncode(jsonData);
    return await flutterSecureStorage.write(
      key: key,
      value: jsonString,
      iOptions: const IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ),
    );
  }

  static Future<String?> getData({required String key}) async {
    return await flutterSecureStorage.read(key: key);
  }

  // Get and decode JSON data
  static Future<dynamic> getJsonData({required String key}) async {
    final jsonString = await flutterSecureStorage.read(key: key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString);
  }

  static Future removeData({required String key}) async {
    return await flutterSecureStorage.delete(key: key);
  }

  static Future removeAllData() async {
    // Fixed: removed unused parameter
    return await flutterSecureStorage.deleteAll();
  }
}