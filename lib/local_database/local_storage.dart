import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String keyUserData = "user_data";
  static const String keyToken = "user_token";
  static const String keyFCMToken = "fcm_token";
  static const String keyIsLoggedIn = "is_logged_in";

  static Future<void> saveLoginData({
    required Map<String, dynamic> userData,
    required String token,
    String? fcmToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUserData, jsonEncode(userData));
    await prefs.setString(keyToken, token);
    if (fcmToken != null) {
      await prefs.setString(keyFCMToken, fcmToken);
    }
    await prefs.setBool(keyIsLoggedIn, true);
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(keyUserData);
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyToken);
  }

  static Future<String?> getFCMToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyFCMToken);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsLoggedIn) ?? false;
  }

  static Future<void> clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyUserData);
    await prefs.remove(keyToken);
    await prefs.remove(keyFCMToken);
    await prefs.setBool(keyIsLoggedIn, false);
  }
}
