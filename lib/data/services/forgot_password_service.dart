import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgotPasswordService {
  String bearerToken = "1234567890";

  Future<String> forgotPassword(String mobile, String password) async {
    final url = Uri.parse(
      "https://sfadmin.in/app/technician/auth/forgot-password.php",
    );

    try {
      final response = await http.post(
        url,
        headers: const {
          "Content-Type": "application/json",
          "Authorization": "Bearer 1234567890",
        },
        body: jsonEncode({
          "mobile": mobile.trim(),
          "new_password": password.trim(),
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data['message'] ?? "Password updated successfully";
      } else {
        return data['message'] ?? "Failed to reset password";
      }
    } catch (e) {
      return "Something went wrong";
    }
  }
}
