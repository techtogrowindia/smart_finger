import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:smart_finger/core/shared_prefs_helper.dart';
import '../../data/models/login_response.dart';

class LoginService {
  String bearerToken = "1234567890";

  Future<LoginResponse> login(String mobile, String password) async {
    final url = Uri.parse("https://sfadmin.in/app/technician/auth/login.php");

    final response = await http.post(
      url,
      headers: const {
        "Content-Type": "application/json",
        "Authorization": "Bearer 1234567890",
      },
      body: jsonEncode({"mobile": mobile.trim(), "password": password.trim()}),
    );

    debugPrint("LOGIN STATUS => ${response.statusCode}");
    debugPrint("LOGIN BODY => ${response.body}");

    final Map<String, dynamic> decodedJson;
    try {
      decodedJson = jsonDecode(response.body);
    } catch (e) {
      throw Exception("Invalid JSON from login API");
    }

    final loginResponse = LoginResponse.fromJson(decodedJson);

    final token = loginResponse.token;

    if (loginResponse.statusCode == 200 && token != null && token.isNotEmpty) {
      await SharedPrefsHelper.saveToken(token);

      final savedToken = await SharedPrefsHelper.getToken();
      debugPrint("TOKEN SAVED => $savedToken");
    } else {
      debugPrint("TOKEN NOT SAVED (missing or invalid)");
    }

    return loginResponse;
  }
}
