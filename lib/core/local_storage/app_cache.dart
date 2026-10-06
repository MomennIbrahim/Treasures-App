 
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AppCache {
  static late SharedPreferences sharedPreferences;

  static Future<void> cacheInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  // For simple values
  static Future<bool> setData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) {
      return await sharedPreferences.setString(key, value);
    }

    if (value is int) {
      return await sharedPreferences.setInt(key, value);
    }

    if (value is double) {
      return await sharedPreferences.setDouble(key, value);
    }

    if (value is bool) {
      return await sharedPreferences.setBool(key, value);
    }

    throw ArgumentError(
      'Unsupported value type: ${value.runtimeType}',
    );
  }

  // For complex objects (Map, List, etc.)
  static Future<bool> setJsonData({
    required String key,
    required dynamic jsonData,
  }) async {
    final jsonString = jsonEncode(jsonData);

    return await sharedPreferences.setString(
      key,
      jsonString,
    );
  }

  // Get simple String value
  static String? getData({
    required String key,
  }) {
    return sharedPreferences.getString(key);
  }

  // Get and decode JSON data
  static dynamic getJsonData({
    required String key,
  }) {
    final jsonString = sharedPreferences.getString(key);

    if (jsonString == null) return null;

    return jsonDecode(jsonString);
  }

  // Get int
  static int? getInt({
    required String key,
  }) {
    return sharedPreferences.getInt(key);
  }

  // Get double
  static double? getDouble({
    required String key,
  }) {
    return sharedPreferences.getDouble(key);
  }

  // Get bool
  static bool? getBool({
    required String key,
  }) {
    return sharedPreferences.getBool(key);
  }

  // Check if key exists
  static bool containsKey({
    required String key,
  }) {
    return sharedPreferences.containsKey(key);
  }

  // Remove specific data
  static Future<bool> removeData({
    required String key,
  }) async {
    return await sharedPreferences.remove(key);
  }

  // Remove all cached data
  static Future<bool> removeAllData() async {
    return await sharedPreferences.clear();
  }
}
 
