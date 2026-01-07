import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_finger/core/shared_prefs_helper.dart';
import 'package:smart_finger/data/models/bank_update_request.dart';

class BankService {
  Future<bool> updateBankDetails(BankUpdateRequest request) async {
    
    final token = await SharedPrefsHelper.getToken();
    final response = await http.post(
      Uri.parse("https://sfadmin.in/app/technician/auth/update-bank-details.php"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(request.toJson()),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["status"] == "success") {
      return true;
    } else {
      throw Exception(data["message"] ?? "Bank update failed");
    }
  }
}
