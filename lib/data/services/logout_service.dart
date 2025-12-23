import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:smart_finger/core/shared_prefs_helper.dart';

class LogoutService {
  static const String _url =
      "https://sfadmin.in/app/technician/auth/logout.php";

  Future<String> logout() async {
    try {
      final token = await SharedPrefsHelper.getToken();

      if (token == null || token.isEmpty) {
        return "FAILED";
      }

      final response = await http.post(
        Uri.parse(_url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      debugPrint("LOGOUT STATUS => ${response.statusCode}");
      debugPrint("LOGOUT BODY => ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == "success") {
          await SharedPrefsHelper.clearToken();
          return "SUCCESS";
        }
      }

      return "FAILED";
    } on SocketException {
      return "NO_INTERNET";
    } catch (e) {
      debugPrint("LOGOUT ERROR => $e");
      return "ERROR";
    }
  }
}
