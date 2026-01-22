import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const tokenKey = "auth_token";
  static const idKey = "user_id";


  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(tokenKey);
  }

  
  static Future<void> saveID(int id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(idKey, id);
  }

  static Future<int?> getID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(idKey);
  }

  // Remember Me credentials
  static const phoneKey = "phone";
  static const passwordKey = "password";
  static const rememberMeKey = "remember_me";

  static Future<void> saveCredentials(
      String phone, String password, bool remember) async {
    final prefs = await SharedPreferences.getInstance();
    if (remember) {
      await prefs.setString(phoneKey, phone);
      await prefs.setString(passwordKey, password);
      await prefs.setBool(rememberMeKey, true);
    } else {
      await prefs.remove(phoneKey);
      await prefs.remove(passwordKey);
      await prefs.setBool(rememberMeKey, false);
    }
  }

  static Future<Map<String, dynamic>> getCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString(phoneKey);
    final password = prefs.getString(passwordKey);
    final remember = prefs.getBool(rememberMeKey) ?? false;

    return {
      "phone": phone ?? "",
      "password": password ?? "",
      "remember": remember,
    };
  }
}
