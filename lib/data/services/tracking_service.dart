import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_finger/core/shared_prefs_helper.dart';
import 'package:smart_finger/data/models/tracking_request_model.dart';

class TrackingService {
  static const String _url =
      "https://sfadmin.in/app/technician/tracking/tracking.php";

  Future<bool> sendTracking(TrackingRequestModel model) async {
    final token = await SharedPrefsHelper.getToken();
    final response = await http.post(
      Uri.parse(_url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(model.toJson()),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['status'] == "success";
    } else {
      throw Exception("Tracking failed");
    }
  }
}
