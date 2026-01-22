import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_finger/core/shared_prefs_helper.dart';
import '../models/notification_model.dart';

class NotificationService {
  final String baseUrl;

  NotificationService({
    this.baseUrl = "https://sfadmin.in/app/technician/auth",
  });

  /// GET notification history
  Future<NotificationResponse> getNotifications() async {
    final token = await SharedPrefsHelper.getToken();
    final url = Uri.parse("$baseUrl/notification-history.php");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status_code'] == 200) {
        return NotificationResponse.fromJson(data);
      } else {
        throw Exception(data['message'] ?? "Something went wrong");
      }
    } else {
      throw Exception("Server error ${response.statusCode}");
    }
  }
}
