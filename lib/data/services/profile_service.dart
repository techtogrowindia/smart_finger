import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:smart_finger/core/shared_prefs_helper.dart';
import '../models/profile_response.dart';

class ProfileService {
  Future<ProfileResponse> getProfile() async {
    final token = await SharedPrefsHelper.getToken();

    final url = Uri.parse("https://sfadmin.in/app/technician/auth/profile.php");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    debugPrint("Profile Status: ${response.statusCode}");
    debugPrint("Profile Response: ${response.body}");

    return ProfileResponse.fromJson(jsonDecode(response.body));
  }
}
